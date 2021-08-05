;;; init-linum.el --- Line numbering
;;; Commentary:
;;; Code:
(require 'use-package)
(require 'linum)

(defun ww/linum-format (line)
  "Format LINE numbers to three digits with a trailing and leading space."
  (let ((w (length (number-to-string (count-lines (point-min) (point-max))))))
    (propertize (format (format " %%%dd " w) line) 'face 'linum)))
(setq linum-format 'ww/linum-format)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'markdown-mode-hook 'linum-mode)

;; highlight line numbers
(use-package hlinum
  :config
  (hlinum-activate))

(provide 'init-linum)
;;; init-linum.el ends here
