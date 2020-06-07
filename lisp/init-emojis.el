;;; init-emojis.el --- Enable emojis
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package emojify
  :pin melpa-stable
  :diminish emojify-mode
  :commands global-emojify-mode
  :hook (after-init . global-emojify-mode)
  :custom
  ;; change to 'image when multi-color fonts are not available
  (emojify-display-style 'unicode)
  (emojify-emoji-styles '(unicode github))
  ;; https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json
  (emojify-emoji-json (expand-file-name "emojis/gitmoji.json" user-emacs-directory))
  :config
  (when (eq system-type 'darwin)
    ;; C-s-<space> fails because MacOS sends a different code for this shortcut
    (global-set-key (kbd "<C-s-268632064>") 'emojify-insert-emoji)))

(provide 'init-emojis)
;;; init-emojis.el ends here
