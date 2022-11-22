;;; init-c.el --- C, C#, C++ modes
;;; Commentary:
;;; Code:
(require 'use-package)

(setq-default c-basic-offset 4)
(add-to-list 'auto-mode-alist '("\\.(ino|c)\\'" . c-mode))

(use-package csharp-mode
  :mode "\\.cs\\'")

(provide 'init-c)
;;; init-c.el ends here
