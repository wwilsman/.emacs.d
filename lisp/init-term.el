;;; init-term.el --- Terminal settings and modes
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package multi-term
  :custom
  (multi-term-program "/bin/zsh")
  (term-suppress-hard-newline t))

(provide 'init-term)
;;; init-term.el ends here
