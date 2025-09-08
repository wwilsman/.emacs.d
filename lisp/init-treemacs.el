;;; init-treemacs.el --- Treemacs -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :after tree-sitter)

(use-package treemacs-all-the-icons
  :demand t
  :after (all-the-icons))

(use-package treemacs
  :demand t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-git-mode 'deferred)
  (treemacs-project-follow-mode t)
  (treemacs-git-commit-diff-mode t)
  (treemacs-fringe-indicator-mode 'always)
  ;;(treemacs-load-all-the-icons-with-workaround-font "Courier New")
  ;;(treemacs-load-theme "all-the-icons")

  (setq treemacs-file-follow-delay 0
        treemacs-no-png-images t
        treemacs--project-follow-delay 0
        treemacs-user-mode-line-format (list "")
        treemacs-user-header-line-format (list "")))

(use-package treemacs-magit
  :demand t
  :after (treemacs magit))

(use-package treemacs-projectile
  :demand t
  :after (treemacs projectile))

(provide 'init-treemacs)
;;; init-treemacs.el ends here
