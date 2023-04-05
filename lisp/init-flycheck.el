;;; init-flycheck.el --- Flycheck settings
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package flycheck
  :diminish flycheck-mode
  :custom
  (flycheck-indication-mode 'right-fringe)
  :config
  ;; make the flycheck error look like an exclamation point
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
    [0 24 24 24 24 24 24 0 0 24 24 0 0 0 0 0 0])
  (global-flycheck-mode))

(provide 'init-flycheck)
;;; init-flycheck.el ends here
