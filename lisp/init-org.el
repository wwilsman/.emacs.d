;;; init-org.el --- Org mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package org
  :custom
  (org-agenda-tags-column 0)
  (org-auto-align-tags nil)
  (org-catch-invisible-edits 'show-and-error)
  (org-ellipsis "…")
  (org-hide-emphasis-markers t)
  (org-insert-heading-respect-content t)
  (org-pretty-entities t)
  (org-special-ctrl-a/e t)
  (org-src-fontify-natively t)
  (org-src-tab-acts-natively t)
  (org-tags-column 0))

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda)
  :custom
  (org-modern-checkbox '((?X .  " ")
                         (?- .  "󰡖 ")
                         (?\s . " "))))

(add-hook 'org-mode-hook 'visual-line-mode)

(provide 'init-org)
;;; init-org.el ends here
