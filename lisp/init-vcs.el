;; highlight diff in fringe
(use-package diff-hl
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (global-diff-hl-mode +1)
  (diff-hl-flydiff-mode))

;; magit
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

;; provide this module
(provide 'init-vcs)
