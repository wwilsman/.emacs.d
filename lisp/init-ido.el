;; ido config
(use-package ido
  :config 
  (setq ido-enable-prefix nil
        ido-use-faces nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point 'guess
        ido-max-prospects 10
        ido-default-file-method 'selected-window
        ido-auto-merge-work-directories-length -1)
  (ido-mode +1))

;; ido-ubiquitous
(use-package ido-ubiquitous
  :config
  (ido-ubiquitous-mode +1))

;; ido-vertical-mode
(use-package ido-vertical-mode
  :config
  (setq ido-vertical-define-keys 'C-n-C-p-up-and-down)
  (ido-vertical-mode +1))

;; flx fuzzy matching
(use-package flx-ido
  :config
  (flx-ido-mode +1))

;; provide this module
(provide 'init-ido)
