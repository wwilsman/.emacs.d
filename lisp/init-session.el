;;; init-session.el --- Sessions in emacs
;;; Commentary:
;;; Code:
(require 'desktop)
(require 'savehist)

;; persist buffers
(setq desktop-dirname (expand-file-name "desktop/" user-emacs-directory)
      desktop-base-file-name "emacs.desktop"
      desktop-base-lock-name "lock"
      desktop-path (list desktop-dirname)
      desktop-save t
      desktop-restore-frames t
      desktop-load-locked-desktop t
      desktop-auto-save-timeout 30)
(desktop-save-mode 1)

;; persist kill-ring
(savehist-mode 1)
(add-to-list 'savehist-additional-variables 'kill-ring)

(provide 'init-session)
;;; init-session.el ends here
