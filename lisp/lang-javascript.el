;; js2/jsx mode
(use-package js2-mode
  :init
  (setq js2-basic-offset 2)
  (setq js2-strict-missing-semi-warning nil)
  (setq js2-missing-semi-one-line-override t)
  :config
  (use-package rjsx-mode
    :mode "\\.jsx?\\'"))

;; provide this module
(provide 'lang-javascript)
