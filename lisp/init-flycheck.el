(use-package flycheck
  :diminish flycheck-mode
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; provide this module
(provide 'init-flycheck)
