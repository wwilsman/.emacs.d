;; editor settings
(setq-default indent-tabs-mode nil)
(setq require-final-newline t
      tab-always-indent 'complete
      ring-bell-function 'ignore
      inhibit-startup-screen t
      tab-width 2)
(global-auto-revert-mode t)
(diminish 'auto-revert-mode)
(delete-selection-mode t)

;; scroll one line at a time
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 1)

;; tmp files
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; provide this module
(provide 'init-editor)
