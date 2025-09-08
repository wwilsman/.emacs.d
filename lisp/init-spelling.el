;;; init-spelling.el --- Spell check settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package ispell
  :custom
  (ispell-choices-win-default-height 3))

(provide 'init-spelling)
;;; init-spelling.el ends here
