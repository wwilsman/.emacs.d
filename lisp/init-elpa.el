;;; init-elpa.el --- Initialize packages
;;; Commentary:
;;; Code:
(require 'package)
(require 'tls)

(setq
 package-enable-at-startup nil
 package-archives
 '(("melpa" . "https://melpa.org/packages/")
   ("melpa-stable" . "https://stable.melpa.org/packages/")
   ;;("gnu" . "http://elpa.gnu.org/packages/"))
   ("gnu" . "http://mirrors.163.com/elpa/gnu/"))
 package-archive-priorities
 '(("melpa" . 10)
   ("melpa-stable" . 5)
   ("gnu" . 0)))

(eval-when-compile
  (package-initialize)

  ;; first run, update package lists
  (or (file-exists-p package-user-dir)
      (package-refresh-contents))

  ;; install essential packages
  (dolist (package (list 'use-package 'diminish 'quelpa))
    (unless (package-installed-p package)
      (package-install package)))

  ;; bootstrap quelpa
  (unless (require 'quelpa nil t)
    (with-temp-buffer
      (url-insert-file-contents "https://framagit.org/steckerhalter/quelpa/raw/master/bootstrap.el")
      (eval-buffer)))

  ;; enable quelpa with use-package
  (quelpa
   '(quelpa-use-package
     :fetcher git
     :url "https://framagit.org/steckerhalter/quelpa-use-package.git"))

  ;; require things for the first time
  (require 'use-package)
  (require 'quelpa-use-package)
  (require 'diminish)

  ;; always ensure packages are installed
  (setq use-package-always-ensure t))

(provide 'init-elpa)
;;; init-elpa.el ends here
