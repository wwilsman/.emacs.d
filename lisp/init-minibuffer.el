;;; init-minibuffer.el --- Initialize minibuffer -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

;; ivy and friends
(use-package ag)
(use-package rg)
(use-package flx)
(use-package smex)
(use-package ivy
  :diminish ivy-mode
  :custom
  (ivy-use-virtual-buffers t)
  :config
  (ivy-mode t))

;; ivy-enhanced commands
(use-package counsel
  :bind (([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library)
         ([remap execute-extended-command] . counsel-M-x)
         ("C-c u" . counsel-unicode-char))
  :bind* (:map counsel-find-file-map
          ([remap ivy-done] . ivy-alt-done))
  :chords (("xx" . counsel-M-x)))

;; ivy search
(use-package swiper
  :bind (("C-s" . swiper)))

;; autocomplete with company
(use-package company
  :diminish company-mode
  :custom
  (company-dabbrev-downcase nil)
  (company-minimum-prefix-length 2)
  (company-tooltip-flip-when-above t)
  :hook (after-init . global-company-mode))

;; nord1 "elevated surface"; nord's TTY default background is `unspecified-bg',
;; so the posframes would otherwise blend into the terminal.
(defvar ww/posframe-background "#3B4252"
  "Background color for the minibuffer/ivy child frames (Nord nord1).")

;; floating minibuffer via posframe (supports TTY child frames, unlike the old
;; mini-frame which is GUI-only).  Only ivy reads float here; see the mirror
;; below for plain minibuffer prompts.
(use-package ivy-posframe
  :after ivy
  :diminish ivy-posframe-mode
  :custom
  (ivy-posframe-display-functions-alist
   '((t . ivy-posframe-display-at-top-fixed)))
  (ivy-posframe-border-width 0)
  ;; fixed width so x stays put; height fits the candidate count
  (ivy-posframe-size-function
   (lambda ()
     (let ((w (round (* (frame-width) 0.75))))
       (list :width w :min-width w :max-width w))))
  ;; hide the child frame's own TTY cursor
  (ivy-posframe-parameters '((tty-non-selected-cursor . nil)
                             (cursor-type . nil)))
  :config
  ;; nord doesn't theme this face, so a plain set persists across `load-theme'
  (set-face-background 'ivy-posframe ww/posframe-background)
  ;; centered, anchored a few rows down (`:font-height' is 1 on a TTY).  The
  ;; name must start with "ivy-posframe" or `ivy-posframe--minibuffer-setup'
  ;; skips hiding the real minibuffer input.
  (defun ivy-posframe-poshandler-top-center-fixed (info)
    (cons (/ (- (plist-get info :parent-frame-width)
                (plist-get info :posframe-width))
             2)
          (* 5 (plist-get info :font-height))))
  (defun ivy-posframe-display-at-top-fixed (str)
    (ivy-posframe--display str #'ivy-posframe-poshandler-top-center-fixed))

  ;; ivy-posframe hides the input by color-matching the overlay to the default
  ;; background, which fails on a TTY (`unspecified-bg'); use `invisible'.
  (defun ww/ivy-posframe--hide-minibuffer-tty (&rest _)
    (when (and ivy-posframe-hide-minibuffer (posframe-workable-p))
      (dolist (ov (overlays-in (point-min) (point-max)))
        (when (overlay-get ov 'ivy-posframe)
          (overlay-put ov 'invisible t)))))
  (advice-add 'ivy-posframe--minibuffer-setup :after
              #'ww/ivy-posframe--hide-minibuffer-tty)

  ;; fringes are GUI-only, so pad the edges with window margins on a TTY
  (defun ww/ivy-posframe--after-display (&rest _)
    (let* ((buf (get-buffer ivy-posframe-buffer))
           (frame (and buf (buffer-local-value 'posframe--frame buf))))
      (when (frame-live-p frame)
        (set-window-margins (frame-root-window frame) 1 1))))
  (advice-add 'ivy-posframe--display :after #'ww/ivy-posframe--after-display)

  ;; ivy-posframe omits `:lines-truncate', so posframe measures height with
  ;; wrapping on and over-sizes the frame for long (swiper/counsel-rg)
  ;; candidates.  Force it so the fit matches the truncated display.
  (defun ww/ivy-posframe--truncate-fit (args)
    (if (and (stringp (car args))
             (string= (car args) ivy-posframe-buffer)
             (not (plist-member (cdr args) :lines-truncate)))
        (append args (list :lines-truncate t))
      args))
  (advice-add 'posframe-show :filter-args #'ww/ivy-posframe--truncate-fit)

  ;; `ivy-height' is the real height lever (posframe fits itself to the
  ;; candidates); grow it to fill the rows below the anchor instead of the
  ;; fixed 10.  A function under key t in `ivy-height-alist' is the default.
  (defun ww/ivy-adaptive-height (&optional _caller)
    (max 5 (- (frame-height) 11)))
  (add-to-list 'ivy-height-alist '(t . ww/ivy-adaptive-height))
  (ivy-posframe-mode 1))

;; Float plain minibuffer prompts (eval-expression, y-or-n-p, ...) that
;; ivy-posframe leaves at the bottom.  The real minibuffer still owns
;; input; we mirror its text plus a fake cursor into a child frame and hide
;; the original (the TTY-safe trick ivy-posframe uses), reusing the
;; ivy-posframe settings and deferring to it for ivy sessions.
(defvar ww/mini-posframe-buffer " *ww-mini-posframe*")
(defvar-local ww/mini-posframe--overlay nil)
(defvar-local ww/mini-posframe--saved-cursor-type nil)

(use-package posframe
  :config
  (defun ww/mini-posframe-active-p ()
    "Non-nil when the mirror should handle the current minibuffer session.
Excludes ivy sessions, which ivy-posframe already floats."
    (let ((win (active-minibuffer-window)))
      (and win
           (window-live-p win)
           (minibufferp (window-buffer win))
           (posframe-workable-p)
           (not (with-current-buffer (window-buffer win)
                  (ivy--completing-p))))))

  (defun ww/mini-posframe-refresh ()
    "Redraw the mirror from the live minibuffer contents."
    (when (ww/mini-posframe-active-p)
      (with-current-buffer (window-buffer (active-minibuffer-window))
        (let* ((raw (buffer-substring (point-min) (point-max)))
               ;; inverse-video block at point stands in for the hidden cursor
               (idx (max 0 (min (length raw) (- (point) (point-min)))))
               (before (substring raw 0 idx))
               (char (if (< idx (length raw)) (substring raw idx (1+ idx)) " "))
               (after (if (< idx (length raw)) (substring raw (1+ idx)) ""))
               (cursor (propertize char 'face '(:inverse-video t)))
               (str (concat before cursor after))
               (w (round (* (frame-width) 0.75))))
          (with-current-buffer (get-buffer-create ww/mini-posframe-buffer)
            ;; wrap so long eval-expression input grows the frame vs hiding the tail
            (setq-local truncate-lines nil word-wrap t))
          (posframe-show
           ww/mini-posframe-buffer
           :string (if (string-empty-p str) " " str)
           :poshandler #'ivy-posframe-poshandler-top-center-fixed
           :width w :min-width w :max-width w
           :min-height 1
           :lines-truncate nil
           :background-color ww/posframe-background
           :internal-border-width ivy-posframe-border-width
           :override-parameters '((tty-non-selected-cursor . nil)
                                   (cursor-type . nil)))
          ;; pad the edges with margins, as with ivy-posframe
          (let ((frame (buffer-local-value 'posframe--frame
                                           (get-buffer ww/mini-posframe-buffer))))
            (when (frame-live-p frame)
              (set-window-margins (frame-root-window frame) 1 1)))))))

  (defun ww/mini-posframe-hide-input ()
    "Hide the real minibuffer input; an invisible overlay works on a TTY."
    (when (ww/mini-posframe-active-p)
      (with-current-buffer (window-buffer (active-minibuffer-window))
        (unless (overlayp ww/mini-posframe--overlay)
          (setq ww/mini-posframe--overlay
                (make-overlay (point-min) (point-max) nil nil t)))
        (move-overlay ww/mini-posframe--overlay (point-min) (point-max))
        (overlay-put ww/mini-posframe--overlay 'invisible t)
        (setq-local cursor-type nil))))

  (defun ww/mini-posframe--start ()
    "Attach the mirror to this minibuffer session."
    (when (and (minibufferp) (posframe-workable-p))
      (setq-local ww/mini-posframe--overlay nil
                  ww/mini-posframe--saved-cursor-type cursor-type)
      (add-hook 'post-command-hook #'ww/mini-posframe-refresh nil t)
      (add-hook 'post-command-hook #'ww/mini-posframe-hide-input nil t)
      ;; draw now so there's no bottom-minibuffer flash before the first command
      (ww/mini-posframe-refresh)
      (ww/mini-posframe-hide-input)))

  (defun ww/mini-posframe--end ()
    "Tear the mirror down when the minibuffer session exits."
    (when (overlayp ww/mini-posframe--overlay)
      (delete-overlay ww/mini-posframe--overlay))
    (setq ww/mini-posframe--overlay nil
          cursor-type ww/mini-posframe--saved-cursor-type)
    (remove-hook 'post-command-hook #'ww/mini-posframe-refresh t)
    (remove-hook 'post-command-hook #'ww/mini-posframe-hide-input t)
    (posframe-hide ww/mini-posframe-buffer))

  (add-hook 'minibuffer-setup-hook #'ww/mini-posframe--start)
  (add-hook 'minibuffer-exit-hook #'ww/mini-posframe--end))

(provide 'init-minibuffer)
;;; init-minibuffer.el ends here
