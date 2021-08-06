;;; init-emojis.el --- Enable emojis
;;; Commentary:
;;; Code:
(require 'use-package)

;; set up emoji fonts
(defun ww/init-emojis ()
  "Initialize emoji support."
  (set-fontset-font t 'symbol "Apple Color Emoji-10")
  (set-fontset-font t 'symbol "Noto Color Emoji-10" nil 'append)
  (set-fontset-font t 'symbol "Segoe UI Emoji-10" nil 'append)
  (set-fontset-font t 'symbol "Symbola-10" nil 'append))

;; in deamons, register emoji init after frame creation
(if (not (daemonp)) (ww/init-emojis)
  (add-hook 'after-make-frame-functions
            (lambda (frame) (select-frame frame) (ww/init-emojis))))

(use-package gitmoji
  :ensure nil ;; already in load-path
  :chords (("xg" . gitmoji-insert)))

(provide 'init-emojis)
;;; init-emojis.el ends here
