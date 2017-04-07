;; auto-pair spacing between brackets/parens
(defun ww/web-mode-insert-space (arg)
  (interactive "*P")
  (let ((prev (char-before))
        (next (char-after)))
    (self-insert-command (prefix-numeric-value arg))
    (if (and prev next
             (string-match-p "[[({]" (string prev))
             (string-match-p "[])}]" (string next)))
        (save-excursion (self-insert-command 1)))))

;; delete paired spacing between brackets/parens
(defun ww/web-mode-delete-space (arg &optional killp)
  (interactive "*p\nP")
  (let ((prev (char-before))
        (next (char-after))
        (pprev (char-before (- (point) 1))))
    (if (and prev next pprev
             (char-equal prev ?\s) (char-equal next ?\s)
             (string-match "[[({]" (string pprev)))
        (delete-char 1))
    (backward-delete-char-untabify arg killp)))

;; set up electric-pair mode
(defun ww/web-mode-electric-pair ()
  (local-set-key " " 'ww/web-mode-insert-space)
  (local-set-key "\177" 'ww/web-mode-delete-space)
  (electric-pair-mode t))

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
         ("\\.css?\\'" . web-mode))
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-quoting nil)
  (setq css-indent-offset 2)

  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

  (add-hook 'web-mode-hook 'ww/web-mode-electric-pair))

;; emmet
(use-package emmet-mode
  :config
  (setq emmet-indentation 2)
  (add-hook 'web-mode-hook 'emmet-mode))

;; provide this module
(provide 'lang-web)
