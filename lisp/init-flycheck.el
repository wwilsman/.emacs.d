;;; init-flycheck.el --- Flycheck settings
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package flycheck
  :diminish flycheck-mode
  :custom
  (flycheck-indication-mode 'right-fringe)
  :hook ((typescript-mode . (lambda () (flycheck-mode -1))))
  :config
  ;; make the flycheck arror look like an exclamation point
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
    [0 24 24 24 24 24 24 0 0 24 24 0 0 0 0 0 0])
  (global-flycheck-mode))

(provide 'init-flycheck)
;;; init-flycheck.el ends here
