;; load path configuration
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; measure startup time
(require 'init-benchmarking)

;; custom config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-elpa) ; calls (package-initialize)

;; fix $PATH
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

;; load configs for specific features and modes
(require 'init-ui)
(require 'init-windowing)
(require 'init-editing)
(require 'init-completion)
(require 'init-projects)
(require 'init-modeline)
(require 'init-flycheck)
(require 'init-dired)
(require 'init-vcs)

;; language specific configs
(require 'lang-web)
(require 'lang-javascript)
(require 'lang-markdown)

;; miscellaneous packages
(use-package sudoku)

;; customize variables
(when (file-exists-p custom-file)
  (load custom-file))

;; provide this module
(provide 'init)
