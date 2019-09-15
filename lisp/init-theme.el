;;; init-theme.el --- Theme settings
;;; Commentary:
;;; Code:
(require 'use-package)

;; dark mode!
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

;; custom base-16 theme based on material palenight
(use-package base16-theme
  :config
  (load-theme 'base16-material-palenight t t)

  (deftheme base16-custom)
  (let ((base00 (plist-get base16-material-palenight-colors :base00))
        (base08 (plist-get base16-material-palenight-colors :base08))
        (base0B (plist-get base16-material-palenight-colors :base0B))
        (base0E (plist-get base16-material-palenight-colors :base0E)))
    (custom-theme-set-faces
     'base16-custom
     `(fringe ((t (:background ,base00))))

     `(linum ((t (:background ,base00))))
     `(linum-highlight-face ((t (:foreground ,base0E :background ,base00))))

     `(diff-hl-change ((t (:background ,base0E))))
     `(diff-hl-delete ((t (:background ,base08))))
     `(diff-hl-insert ((t (:background ,base0B))))

     `(web-mode-html-tag-face ((t (:inherit font-lock-constant-face :foreground nil))))
     `(web-mode-html-attr-name-face ((t (:inherit font-lock-variable-name-face :foreground nil))))
     `(web-mode-html-attr-value-face ((t (:inherit font-lock-preprocessor-face :foreground nil))))

     `(rjsx-tag ((t (:inherit font-lock-constant-face))))
     `(rjsx-attr ((t (:inherit font-lock-variable-name-face))))))

  (enable-theme 'base16-material-palenight)
  (enable-theme 'base16-custom))

;; rainbow mode for colors
(use-package rainbow-mode
  :diminish rainbow-mode
  :hook css-mode)

;; rainbow delimiters
(use-package rainbow-delimiters
  :diminish rainbow-delimiters-mode
  :hook (prog-mode . rainbow-delimiters-mode))

(provide 'init-theme)
;;; init-theme.el ends here
