;; smart-mode-line
(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t
        sml/theme 'respectful)
  (add-hook 'after-init-hook #'sml/setup))

;; nyanyanyanyanyanyanya
(use-package nyan-mode
  :config
  (unless nyan-mode (nyan-mode t)))

;; provide this module
(provide 'init-modeline)
