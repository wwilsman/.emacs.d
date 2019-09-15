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
  (emojify-display-style 'unicode)
  (emojify-emoji-styles '(github))
  ;; https://raw.githubusercontent.com/carloscuesta/gitmoji/master/src/data/gitmojis.json
  (emojify-emoji-json (expand-file-name "emojis/gitmoji.json" user-emacs-directory)))

(provide 'init-emojis)
;;; init-emojis.el ends here
