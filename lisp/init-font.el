;;; init-font.el --- Font settings
;;; Commentary:
;;; Code:

;; set up font + ligatures
(defun ww/init-font ()
  "Initialize font-face attributes."
  (when (find-font (font-spec :name "Operator Mono Lig"))
    (add-to-list 'default-frame-alist '(font . "Operator Mono Lig"))
    (set-face-attribute 'default nil :font "Operator Mono Lig" :height 120)

    ;; ligatures
    (dolist (char-regexp
             '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")))
      (set-char-table-range composition-function-table (car char-regexp)
                            `([,(cdr char-regexp) 0 font-shape-gstring])))

    ;; cursive keywords
    (set-face-italic 'font-lock-builtin-face t)
    (set-face-italic 'font-lock-constant-face t)
    (set-face-italic 'font-lock-keyword-face t)
    (set-face-italic 'font-lock-type-face t)
    (set-face-italic 'font-lock-function-name-face t)

    ;; mode specific attributes
    (defun ww/web-mode-face-attributes ()
      "Set font face attributes for web-mode."
      (set-face-italic 'web-mode-html-attr-name-face t)
      (set-face-italic 'web-mode-css-property-name-face t)
      (set-face-italic 'web-mode-css-pseudo-class-face t))
    (add-hook 'web-mode-hook 'ww/web-mode-face-attributes)

    (defun ww/rjsx-mode-face-attributes ()
      "Set font face attributes for rjsx-mode."
      (set-face-italic 'rjsx-attr t))
    (add-hook 'rjsx-mode-hook 'ww/rjsx-mode-face-attributes)

    (defun ww/adjust-line-spacing ()
      "Set font line-spacing for specific modes."
      (setq line-spacing 0.2))
    (add-hook 'text-mode-hook 'ww/adjust-line-spacing)
    (add-hook 'prog-mode-hook 'ww/adjust-line-spacing)))

;; in deamons, register font init after frame creation
(if (not (daemonp)) (ww/init-font)
  (add-hook 'after-make-frame-functions
            (lambda (frame) (select-frame frame) (ww/init-font))))

(provide 'init-font)
;;; init-font.el ends here
