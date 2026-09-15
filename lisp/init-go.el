;;; init-go.el --- Go language support -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package go-mode
  :mode "\\.go\\'"
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(provide 'init-go)
;;; init-go.el ends here
