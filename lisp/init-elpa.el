(require 'package)

;; Use melpa for most packages
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; fire up package.el
(setq package-enable-at-startup nil)
(package-initialize)

;; refresh package-archives
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

;; install initial packages
(dolist (package '(use-package diminish))
  (unless (package-installed-p package)
    (package-install package)))

;; require them
(eval-when-compile (require 'use-package))
(require 'diminish)

;; always ensure packages are installed
(setq use-package-always-ensure t)

;; provide this module
(provide 'init-elpa)
