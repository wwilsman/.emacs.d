;;; init-path.el --- Initialize $PATH
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package exec-path-from-shell
  :custom
  (exec-path-from-shell-check-startup-files nil)
  :config
  (exec-path-from-shell-initialize))

(provide 'init-path)
;;; init-path.el ends here
