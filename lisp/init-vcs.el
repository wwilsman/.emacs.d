;;; init-vcs.el --- Version control settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

;; magit
(use-package magit
  :bind ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function #'ww/magit-display-buffer)
  (magit-read-worktree-directory-function #'ww/magit-read-worktree-directory)
  :config
  (defun ww/magit-read-worktree-directory (prompt commit)
    "Read a worktree directory as a sibling named after COMMIT only.
Like `magit-read-worktree-directory-sibling' but without prefixing
the name with the current worktree's."
    (read-directory-name
     prompt
     (file-name-directory (directory-file-name default-directory))
     nil nil
     (and commit (string-replace "/" "-" commit))))

  (defun ww/magit-display-buffer (buffer)
    "Display magit BUFFER based on frame orientation.
Status and the commit diff get special handling; other buffers fall
through to `magit-display-buffer-traditional'.  Portrait status goes
fullframe; portrait commit diff goes below the commit message."
    (let ((mode (with-current-buffer buffer major-mode)))
      (cond
       ((eq mode 'magit-status-mode)
        (cond
         ((ww/frame-portrait-p)
          (magit-display-buffer-fullframe-status-v1 buffer))
         ((= (length (window-list)) 1)
          (display-buffer buffer '(display-buffer-in-direction
                                   (direction . right))))
         (t
          (display-buffer buffer '(display-buffer-same-window)))))
       ;; commit diff is shown noselect, so the selected window still holds
       ;; the commit message buffer here
       ((and (eq mode 'magit-diff-mode)
             (ww/frame-portrait-p)
             (with-current-buffer (window-buffer (selected-window))
               (bound-and-true-p git-commit-mode)))
        (display-buffer buffer '((display-buffer-reuse-window
                                  display-buffer-below-selected))))
       (t (magit-display-buffer-traditional buffer))))))

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
