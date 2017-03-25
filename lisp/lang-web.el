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
         ("\\.jsx?\\'" . web-mode))
  :init
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2)
  (setq web-mode-enable-auto-quoting nil)
  (setq css-indent-offset 2)

  (setq web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'")))

  (add-hook 'web-mode-hook
            (lambda ()
              (electric-pair-mode t)
              (setq electric-pair-pairs '((?\' . ?\') (?\< . ?\>)))
              (local-set-key " " 'ww/web-mode-insert-space)
              (local-set-key "\177" 'ww/web-mode-delete-space))))

;; emmet
(use-package emmet-mode
  :init
  (setq emmet-indentation 2)
  :config
  (add-hook 'css-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))

;; provide this module
(provide 'lang-web)
