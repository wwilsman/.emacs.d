;;; init-editing.el --- Editing utils
;;; Commentary:
;;; Code:
(require 'quelpa-use-package)

;; spaces > tabs
(setq-default indent-tabs-mode nil
              tab-always-indent 'complete
              tab-width 2)

;; default fill-column
(setq-default fill-column 100)

;; show trailing whitespace in prog-mode
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; missing newlines can mess up diffs
(setq require-final-newline t)

;; silence!
(setq ring-bell-function 'ignore)

;; some packages modify key-bindings themselves and produce noisy messages
(setq ad-redefinition-action 'accept)

;; temp file locations
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; prevent lockfiles
(setq create-lockfiles nil)

;; auto revert
(global-auto-revert-mode t)
(diminish 'auto-revert-mode)

;; y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; delete selections
(delete-selection-mode t)

;; show matching parens
(show-paren-mode t)

;; pixel precision scrolling
(pixel-scroll-precision-mode t)

;; autosave buffers with names
(defadvice switch-to-buffer (before save-buffer-now activate)
  "Autosave file on buffer switch."
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
;; autosave when focus is lost
(add-hook 'focus-out-hook (lambda () (when buffer-file-name (save-buffer))))

;; xref enter as tab
(use-package xref
  :bind (:map xref--xref-buffer-mode-map
         ("<return>" . xref-quit-and-goto-xref)))

;; key-chords
(use-package use-package-chords
  :config (key-chord-mode 1))

;; jump anywhere
(use-package ace-jump-mode
  :chords (("jj" . ace-jump-char-mode)
           ("jk" . ace-jump-word-mode)
           ("jl" . ace-jump-line-mode)))

;; ridiculously useful extenstions
(use-package crux
  :bind (([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)
         ("C-c r" . crux-rename-file-and-buffer)
         :map window-swap-map
         ("s" . crux-transpose-windows))
  :chords (("JJ" . crux-switch-to-previous-buffer))
  :config
  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify))

(defun ww/toggle-indent-tabs-mode ()
  "Toggle the 'indent-tabs-mode' variable."
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message
   (concat
    "'indent-tabs-mode' is "
    (or (and indent-tabs-mode "t") "nil"))))
(bind-key "C-c <tab>" `ww/toggle-indent-tabs-mode)

;; ability to restart emacs quickly
(use-package restart-emacs)

;; auto open/close pairs
(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :config
  (smartparens-global-mode 1))

;; useful to browse kill-ring
(use-package browse-kill-ring
  :chords (("yy" . browse-kill-ring)))

;; undo-tree
(use-package undo-tree
  :diminish undo-tree-mode
  :chords (("uu" . undo-tree-visualize))
  :custom
  (undo-tree-history-directory-alist `((".*" . ,temporary-file-directory)))
  (undo-tree-auto-save-history t)
  :config
  (global-undo-tree-mode))

;; which key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode t))

(use-package yasnippet
  :config
  (yas-global-mode t))

;; highlight changes
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config
  (volatile-highlights-mode t))

;; multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))
(use-package mc-modal-mode
  :ensure nil ; already in load-path
  :bind (("C-c ." . mc-modal-mode)))

;; move lines
(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

;; kill the current line or region
(use-package whole-line-or-region
  :config
  (whole-line-or-region-global-mode))

;; smart trim whitespace
(use-package whitespace-cleanup-mode
  :diminish whitespace-cleanup-mode
  :hook (after-init . global-whitespace-cleanup-mode))

;; expand region
(use-package expand-region
  :ensure nil ; quelpa will take care of this
  :quelpa (expand-region :fetcher github :repo "magnars/expand-region.el")
  :bind (("C-=" . er/expand-region)))

;; manipulate numbers
(defun ww/increment-number-at-point (&optional arg)
  "Increment the number at point by ARG."
  (interactive "p*")
  (save-excursion
    (save-match-data
      (let (inc-by field-width answer)
        (setq inc-by (if arg arg 1))
        (skip-chars-backward "0123456789")
        (when (re-search-forward "[0-9]+" nil t)
          (setq field-width (- (match-end 0) (match-beginning 0)))
          (setq answer (+ (string-to-number (match-string 0) 10) inc-by))
          (when (< answer 0)
            (setq answer (+ (expt 10 field-width) answer)))
          (replace-match (format (concat "%0" (int-to-string field-width) "d")
                                 answer)))))))

(defun ww/decrement-number-at-point (&optional arg)
  "Decrement the number at point by ARG."
  (interactive "p*")
  (ww/increment-number-at-point (if arg (- arg) -1)))

(bind-key "C-c C-p" `ww/increment-number-at-point)
(bind-key "C-c C-n" `ww/decrement-number-at-point)

(provide 'init-editing)
;;; init-editing.el ends here
