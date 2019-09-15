;;; init-macos.el --- Mac OS specific config
;;; Commentary:
;;; Code:

(when (eq system-type 'darwin)
  ;; bind common os commands to equivalent emacs commands
  (global-set-key [(super a)] 'mark-whole-buffer)
  (global-set-key [(super v)] 'yank)
  (global-set-key [(super c)] 'kill-ring-save)
  (global-set-key [(super s)] 'save-buffer)
  (global-set-key [(super l)] 'goto-line)
  (global-set-key [(super w)]
                  (lambda () (interactive) (delete-window)))
  (global-set-key [(super z)] 'undo)

  ;; show emojis
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend)

  ;; fix artist mode right click
  (eval-after-load 'artist'
  '(define-key
     artist-mode-map
     [down-mouse-3]
     'artist-mouse-choose-operation)))

(provide 'init-macos)
;;; init-macos.el ends here
