;;; init-session.el --- Sessions in emacs
;;; Commentary:
;;; Code:
(require 'desktop)
(require 'savehist)
(require 'midnight)

;; persist buffers
(setq
 desktop-dirname (expand-file-name "desktop/" user-emacs-directory)
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

;; clean up untouched buffers
(defvar clean-buffer-list-timer nil
  "Stores 'clean-buffer-list' timer if there is one.
Disable 'clean-buffer-list' with (cancel-timer clean-buffer-list-timer).")

(setq
 ;; kill buffers if they were last touched more than 15 minutes ago
 clean-buffer-list-delay-special 900
 ;; run clean-buffer-list every 2 hours
 clean-buffer-list-timer (run-at-time t 7200 'clean-buffer-list)
 ;; kill everything, clean-buffer-list is very intelligent at not killing unsaved buffers
 clean-buffer-list-kill-regexps '("^.*$")
 ;; always keep these buffer alive
 clean-buffer-list-kill-never-buffer-names
 (append '("*Messages*" "*cmd*" "*scratch*") clean-buffer-list-kill-never-buffer-names))

(provide 'init-session)
;;; init-session.el ends here
