;;; init-web.el --- Web mode
;;; Commentary:
;;; Code:
(require 'use-package)

;; web-mode
(use-package web-mode
  :mode (("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.html?\\'" . web-mode)
         ("\\.hbs?\\'" . web-mode)
         ("\\.[tj]sx?\\'" . web-mode)
         ("\\.css?\\'" . web-mode))
  :custom
  (web-mode-content-types-alist '(("jsx" . "\\.[mc]?js[x]?\\'")))
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-auto-quoting nil)
  (css-indent-offset 2)
  :init
  (defun ww/web-mode-insert-space (arg)
    "Insert spaces between brackets & parens."
    (interactive "*P")
    (let ((prev (char-before))
          (next (char-after)))
      (self-insert-command (prefix-numeric-value arg))
      (if (and prev next
               (string-match-p "[[({]" (string prev))
               (string-match-p "[])}]" (string next)))
          (save-excursion (self-insert-command 1)))))
  (defun ww/web-mode-delete-space (arg &optional killp)
    "Delete spaces between brakcets & parens."
    (interactive "*p\nP")
    (let ((prev (char-before))
          (next (char-after))
          (pprev (char-before (- (point) 1))))
      (if (and prev next pprev
               (char-equal prev ?\s) (char-equal next ?\s)
               (string-match "[[({]" (string pprev)))
          (delete-char 1))
      (backward-delete-char-untabify arg killp)))
  :hook (web-mode . (lambda ()
                      (local-set-key " " 'ww/web-mode-insert-space)
                      (local-set-key "\177" 'ww/web-mode-delete-space)
                      (electric-pair-mode t))))

;; emmet
(use-package emmet-mode
  :hook (sgml-mode web-mode)
  :custom (emmet-indentation 2))

(provide 'init-web)
;;; init-web.el ends here
