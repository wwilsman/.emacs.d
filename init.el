;;; init.el --- Emacs initialization
;;; Commentary:
;;; Code:

;; load-path configuration
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "site-lisp" user-emacs-directory))

;; measure startup time
(require 'init-benchmarking)

;; custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; start emacs server when not running
(require 'server)
(unless (server-running-p) (server-start))

;; initial configs
(require 'init-ui)
(require 'init-elpa)

;; language specific configs
(require 'init-web)
(require 'init-javascript)
(require 'init-markdown)
(require 'init-yaml)
(require 'init-lua)
(require 'init-c)

;; language server
(require 'init-lsp)

;; feature configs
(require 'init-path)
(require 'init-macos)
(require 'init-linum)
(require 'init-windowing)
(require 'init-editing)
(require 'init-session)
(require 'init-theme)
(require 'init-emojis)
(require 'init-minibuffer)
(require 'init-projectile)
(require 'init-modeline)
(require 'init-flycheck)
(require 'init-term)
(require 'init-dired)
(require 'init-vcs)
;(require 'init-tracking)

(provide 'init)
;;; init.el ends here
