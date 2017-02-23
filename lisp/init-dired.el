(use-package dired+
  :config
  (setq diredp-hide-details-initially-flag nil)
  (diredp-toggle-find-file-reuse-dir 1))

;; provide this module
(provide 'init-dired)
