(use-package ws-trim
  :ensure nil
  :load-path "site-lisp/"
  :diminish ws-trim-mode
  :config
  (setq ws-trim-level 1)
  (global-ws-trim-mode +1))

;; provide this module
(provide 'init-whitespace)
