;;; init-markdown.el --- Markdown mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :custom
  (markdown-header-scaling t)
  (markdown-fontify-code-blocks-natively t)
  (markdown-command "cmark-gfm")
  :hook (markdown-mode . auto-fill-mode))

(use-package markdown-preview-mode
  :after (markdown-mode))

(use-package grip-mode
  :demand t
  :after (markdown-mode)
  :custom
  (grip-preview-use-webkit (featurep 'xwidget-internal))
  (grip-update-after-change nil)
  :bind (:map markdown-mode-command-map
         ("g" . grip-mode)))

(provide 'init-markdown)
;;; init-markdown.el ends here
