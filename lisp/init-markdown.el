;;; init-markdown.el --- Markdown mode
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :hook (markdown-mode . auto-fill-mode))

(provide 'init-markdown)
;;; init-markdown.el ends here
