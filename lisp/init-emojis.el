;;; init-emojis.el --- Enable emojis
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package gitmoji
  :ensure nil ; already in load-path
  :diminish gitmoji-commit-mode
  :config
  (gitmoji-commit-mode t))

(provide 'init-emojis)
;;; init-emojis.el ends here
