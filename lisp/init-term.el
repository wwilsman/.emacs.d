;;; init-term.el --- Terminal settings and modes -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(setq shell-file-name
      (if (file-exists-p "/opt/homebrew/bin/fish")
          "/opt/homebrew/bin/fish"
        "/bin/bash"))

(use-package eat
  :quelpa (eat :fetcher git
               :url "https://codeberg.org/akib/emacs-eat"
               :files ("*.el" ("term" "term/*.el") "*.texi"
                       "*.ti" ("terminfo/e" "terminfo/e/*")
                       ("terminfo/65" "terminfo/65/*")
                       ("integration" "integration/*")
                       (:exclude ".dir-locals.el" "*-tests.el"))))

(provide 'init-term)
;;; init-term.el ends here
