;; load path configuration
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; measure startup time
(require 'init-benchmarking)

;; custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-elpa) ; calls (package-initialize)

;; load configs for specific features and modes
(require 'init-window)
(require 'init-editor)
(require 'init-theme)
(require 'init-font)

(require 'init-ido)
(require 'init-smex)
(require 'init-dired)
(require 'init-kill-ring)
(require 'init-which-key)
(require 'init-modeline)
(require 'init-volatile-highlights)
(require 'init-multiple-cursors)
(require 'init-move-lines)
(require 'init-crux)
(require 'init-git)
(require 'init-projectile)
(require 'init-company)
(require 'init-flycheck)
(require 'init-whitespace)

;; language specific configs
(require 'init-web)
(require 'init-javascript)
(require 'init-markdown)

;; miscellaneous packages
(use-package sudoku)

;; customize variables
(when (file-exists-p custom-file)
  (load custom-file))

;; provide this module
(provide 'init)
