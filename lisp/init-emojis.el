;;; init-emojis.el --- Enable emojis -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

;; set up emoji fonts
(set-fontset-font t 'symbol "Apple Color Emoji-10")
(set-fontset-font t 'symbol "Noto Color Emoji-10" nil 'append)
(set-fontset-font t 'symbol "Segoe UI Emoji-10" nil 'append)
(set-fontset-font t 'symbol "Symbola-10" nil 'append)

(use-package gitmoji
  :ensure nil ;; already in load-path
  :chords (("xg" . gitmoji-insert)))

(provide 'init-emojis)
;;; init-emojis.el ends here
