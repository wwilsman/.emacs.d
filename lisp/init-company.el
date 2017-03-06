(use-package company
  :diminish company-mode
  :config
  (global-company-mode +1)
  (setq company-dabbrev-downcase nil))

;; provide this module
(provide 'init-company)
