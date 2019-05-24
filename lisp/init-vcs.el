;;; init-vcs.el --- Version control settings
;;; Commentary:
;;; Code:
(require 'use-package)

;; magit
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch-popup)))

;; highlight diff in fringe
(use-package diff-hl
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)
  :custom
  (diff-hl-draw-borders nil)
  :config
  (global-diff-hl-mode t)
  (diff-hl-flydiff-mode))

;; use pinentry for gpg
(use-package pinentry
  :config
  (pinentry-start))

(provide 'init-vcs)
;;; init-vcs.el ends here
