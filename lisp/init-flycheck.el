(use-package flycheck
  :diminish flycheck-mode
  :config
  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; provide this module
(provide 'init-flycheck)
