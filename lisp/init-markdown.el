;;; init-markdown.el --- Markdown mode
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :hook (markdown-mode . auto-fill-mode))

(use-package grip-mode
  :demand t
  :after (markdown-mode)
  :custom
  (grip-preview-use-webkit (featurep 'xwidget-internal))
  :bind (:map markdown-mode-command-map
         ("g" . grip-mode)))

(provide 'init-markdown)
;;; init-markdown.el ends here
