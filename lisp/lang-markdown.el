;; markdown mode
(use-package markdown-mode
  :mode ("\\.md\\'" . gfm-mode)
  :config
  (add-hook 'markdown-mode-hook `auto-fill-mode))

;; provide this module
(provide 'lang-markdown)
