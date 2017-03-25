(use-package dired+
  :init
  (setq diredp-hide-details-initially-flag nil)
  (setq diredp-hide-details-propagate-flag nil)
  :config
  (diredp-toggle-find-file-reuse-dir 1))

;; provide this module
(provide 'init-dired)
