;; ui settings
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(global-hl-line-mode +1)

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

;; provide this module
(provide 'init-theme)
