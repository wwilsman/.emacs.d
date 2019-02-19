;;; init-term.el --- Terminal settings and modes
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package multi-term
  :custom
  (multi-term-program "/bin/zsh"))

(provide 'init-term)
;;; init-term.el ends here
