;;; init-c.el --- C, C#, C++ modes
;;; Commentary:
;;; Code:

(setq-default c-basic-offset 4)
(add-to-list 'auto-mode-alist '("\\.(ino|c)\\'" . c-mode))

(provide 'init-c)
;;; init-c.el ends here
