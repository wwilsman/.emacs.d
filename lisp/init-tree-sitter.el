;;; init-tree-sitter.el --- Tree-sitter config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

(provide 'init-tree-sitter)
;;; init-tree-sitter.el ends here
