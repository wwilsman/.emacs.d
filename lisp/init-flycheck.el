(use-package flycheck
  :diminish flycheck-mode
  :config
  (setq flycheck-indication-mode 'right-fringe)

  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
    [0 0 0 0 0 4 12 28 60 124 252 124 60 28 12 4 0 0 0 0])

  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; provide this module
(provide 'init-flycheck)
