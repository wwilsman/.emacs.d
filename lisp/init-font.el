;; font settings
(setq-default line-spacing 0.5)

;; set up "Fira Code" font + ligatures
(when (find-font (font-spec :name "Fira Code"))
  (add-to-list 'default-frame-alist '(font . "Fira Code-12"))
  (set-face-attribute 'default t :font "Fira Code-12")

  ;; "Fira Code" ligatures
  (let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
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
                 (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
                 )
               ))
    (dolist (char-regexp alist)
      (set-char-table-range composition-function-table (car char-regexp)
                            `([,(cdr char-regexp) 0 font-shape-gstring]))))

  ;; use "Operator Mono" for cursive keywords
  (when (find-font (font-spec :name "Operator Mono"))
    (set-face-attribute 'font-lock-constant-face nil :family "Operator Mono" :italic t)
    (set-face-attribute 'font-lock-keyword-face nil :family "Operator Mono" :italic t)
    (set-face-attribute 'font-lock-type-face nil :family "Operator Mono" :italic t)
    (set-face-attribute 'font-lock-function-name-face nil :family "Operator Mono" :italic t)))

;; set web-mode specific face-attributes
(defun ww/web-mode-face-attributes ()
  (when (find-font (font-spec :name "Operator Mono"))
    (set-face-attribute 'web-mode-html-attr-name-face nil :family "Operator Mono" :italic t)))
(add-hook 'web-mode-hook 'ww/web-mode-face-attributes)

;; set css-mode specific face-attributes
(defun ww/css-mode-face-attributes ()
  (when (find-font (font-spec :name "Operator Mono"))
    (set-face-attribute 'css-property nil :family "Operator Mono" :italic t)))
(add-hook 'css-mode-hook 'ww/css-mode-face-attributes)

;; provide this module
(provide 'init-font)
