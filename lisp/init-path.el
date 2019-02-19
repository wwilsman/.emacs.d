;;; init-path.el --- Initialize $PATH
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(provide 'init-path)
;;; init-path.el ends here
