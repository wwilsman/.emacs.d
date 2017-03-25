;; js2/jsx mode
(use-package js2-mode
             :config
             (setq js2-basic-offset 2
                   js2-strict-missing-semi-warning nil
                   js2-missing-semi-one-line-override t)
             (use-package rjsx-mode
                          ;; :mode "\\.jsx?\\'"
                          ))

;; provide this module
(provide 'lang-javascript)
