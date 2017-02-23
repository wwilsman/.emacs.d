;; git gutter
(use-package git-gutter
  :config
  (global-git-gutter-mode +1)
  (add-hook `prog-mode-hook `git-gutter-mode))

;; magit
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

;; provide this module
(provide 'init-git)
