;;; init-spelling.el --- Spell check settings
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package ispell
  :custom
  (ispell-choices-win-default-height 3))

(provide 'init-spelling)
;;; init-spelling.el ends here
