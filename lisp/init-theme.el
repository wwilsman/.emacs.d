;; ui settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

;; line-number
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(fset 'yes-or-no-p 'y-or-n-p)

;; theme
(use-package material-theme
  :config
  (load-theme `material t))

;; rainbow delimiters
(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

;; highlight-line
(use-package hl-line
  :config
  (setq hl-line-sticky-flag nil
        global-hl-line-sticky-flag nil)
  (add-hook 'prog-mode-hook 'hl-line-mode))

;; linenum
(use-package nlinum
  :preface
  (setq linum-format "%3d ")
  (defvar nlinum-format "%4d ")
  :config
  (global-nlinum-mode +1)
  (defun ww/set-nlinum-width ()
    (setq-local nlinum-format
                (concat "%" (number-to-string
                             (+ 1 (length (save-excursion
                                            (goto-char (point-max))
                                            (format-mode-line "%l")))))
                        "d ")))
  (add-hook 'nlinum-mode-hook 'ww/set-nlinum-width))

;; provide this module
(provide 'init-theme)
