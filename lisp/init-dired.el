(use-package dired+
  :config
  (diredp-toggle-find-file-reuse-dir 1)
  (setq diredp-hide-details-initially-flag nil
        diredp-hide-details-propagate-flag nil))

;; provide this module
(provide 'init-dired)
