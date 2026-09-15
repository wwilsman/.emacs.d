;;; init-theme.el --- Theme settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)
(require 'quelpa-use-package)

;; dark mode!
(when (eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
  (add-to-list 'default-frame-alist '(ns-appearance . dark)))
(add-to-list 'default-frame-alist '(border-width . 1))

;; font setup
(setq-default line-spacing 0.6)

(defun ww/activate-victor-mono ()
  "Activate the Victor Mono font if available."
  (when (find-font (font-spec :name "Victor Mono"))
    (add-to-list 'default-frame-alist '(font . "Victor Mono-10"))

    ;; ligatures
    (dolist (char-regexp '(
        (33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
        (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
        (36 . ".\\(?:>\\)")
        (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
        (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
        (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
        (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
        (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
        (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
        (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
        (48 . ".\\(?:x[a-zA-Z]\\)")
        (58 . ".\\(?:::\\|[:=]\\)")
        (59 . ".\\(?:;;\\|;\\)")
        (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
        (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
        (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
        (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
        (91 . ".\\(?:]\\)")
        (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
        (94 . ".\\(?:=\\)")
        (119 . ".\\(?:ww\\)")
        (123 . ".\\(?:-\\)")
        (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
        (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")))
      (set-char-table-range composition-function-table
        (car char-regexp) `([,(cdr char-regexp) 0 font-shape-gstring])))

    ;; italic faces
    (set-face-italic 'font-lock-builtin-face t)
    (set-face-italic 'font-lock-comment-face t)
    (set-face-italic 'font-lock-constant-face t)
    (set-face-italic 'font-lock-doc-face t)
    (set-face-italic 'font-lock-function-name-face t)
    (set-face-italic 'font-lock-keyword-face t)

    (with-eval-after-load 'web-mode
      (set-face-italic 'web-mode-html-attr-name-face t)
      (set-face-italic 'web-mode-css-property-name-face t)
      (set-face-italic 'web-mode-css-pseudo-class-face t))))

;; rainbow mode for colors
(use-package rainbow-mode
  :diminish rainbow-mode
  :hook css-mode)

;; rainbow delimiters
(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :hook (prog-mode . rainbow-delimiters-mode))

;; nord theme
(use-package nord-theme
  :init
  ;; upstream nord-theme.el ships without a `lexical-binding' cookie, which
  ;; Emacs 30+ warns about. The warning fires from several channels (the
  ;; implicit `require' below, `load-theme', byte/native compilation); all of
  ;; them funnel through `display-warning', so drop just this file's cookie
  ;; warning there and leave every other package's warnings intact.
  (advice-add 'display-warning :around
    (lambda (orig type message &rest args)
      (unless (and (string-match-p "nord-theme" (format "%s" message))
                   (string-match-p "lexical-binding" (format "%s" message)))
        (apply orig type message args))))
  :config
  (setq underline-minimum-offset 5)

  (defun ww/customize-nord ()
    "Customize Nord theme colors."
    (let ((bg (if (display-graphic-p)
                  (face-background 'default)
                "unspecified-bg"))
          (fg (face-foreground 'font-lock-comment-face))
          (highlight-fg (face-foreground 'font-lock-keyword-face)))
      (set-face-attribute 'default nil :background bg)
      (set-face-attribute 'mode-line nil :background bg)
      (set-face-attribute 'mode-line-inactive nil :background bg)
      (set-face-attribute 'line-number nil :foreground fg :background bg)
      (set-face-attribute 'line-number-current-line nil :foreground highlight-fg :background bg)))

  ;; merge conflict highlighting (using nord colors)
  (with-eval-after-load 'smerge-mode
    (set-face-attribute 'smerge-upper nil
                        :background "#5E81AC" :foreground "#ECEFF4" :extend t)  ; nord frost blue
    (set-face-attribute 'smerge-lower nil
                        :background "#8FBCBB" :foreground "#2E3440" :extend t)  ; nord frost cyan
    (set-face-attribute 'smerge-base nil
                        :background "#B48EAD" :foreground "#2E3440" :extend t)  ; nord aurora purple
    (set-face-attribute 'smerge-markers nil
                        :background "#4C566A" :foreground "#D8DEE9" :extend t)) ; nord polar night

  (if (daemonp)
    (add-hook 'after-make-frame-functions (lambda (frame)
      (with-selected-frame frame
        (load-theme 'nord t)
        (ww/customize-nord)
        (when (window-system frame)
          (ww/activate-victor-mono)))))
    (progn
      (load-theme 'nord t)
      (ww/customize-nord)
      (when (display-graphic-p)
        (ww/activate-victor-mono)))))

(use-package all-the-icons
  :config
  (if (and (window-system) (not (find-font (font-spec :name "all-the-icons"))))
    (all-the-icons-install-fonts t)))

(provide 'init-theme)
;;; init-theme.el ends here
