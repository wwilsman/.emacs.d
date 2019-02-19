;;; init-linum.el --- Line numbering
;;; Commentary:
;;; Code:
(require 'use-package)

(global-linum-mode t)

;; highlight line numbers
(use-package hlinum
  :custom
  (linum-format
   (lambda (line)
     (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
       (propertize (format (format "%%%dd " w) line) 'face 'linum))))
  :config
  (hlinum-activate))

(provide 'init-linum)
;;; init-linum.el ends here
