(use-package flycheck
  :diminish flycheck-mode
  :config
  (setq flycheck-indication-mode 'right-fringe)

  (define-fringe-bitmap 'ww/flycheck-fringe-indicator
    (vector #b00000000
            #b00011000
            #b00011000
            #b00011000
            #b00011000
            #b00011000
            #b00011000
            #b00000000
            #b00000000
            #b00011000
            #b00011000
            #b00000000
            #b00000000
            #b00000000
            #b00000000
            #b00000000))

  (flycheck-define-error-level 'error
    :severity 2
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap `ww/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-error)
  (flycheck-define-error-level 'warning
    :severity 1
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap `ww/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-warning)
  (flycheck-define-error-level 'info
    :severity 0
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap `ww/flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-info)

  (flycheck-add-mode 'javascript-eslint 'web-mode)
  (add-hook 'prog-mode-hook 'flycheck-mode))

;; provide this module
(provide 'init-flycheck)
