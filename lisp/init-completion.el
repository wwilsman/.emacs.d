;; code searching
(use-package ag)

;; ivy completion frontend & search
(use-package swiper
  :diminish ivy-mode
  :bind (([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library)
         ([remap execute-extended-command] . counsel-M-x)
         ("C-c u" . counsel-unicode-char))
  :bind* (:map counsel-find-file-map
          ([remap ivy-done] . ivy-alt-done))
  :config
  (setq ivy-use-virtual-buffers t)
  (ivy-mode t))

;; autocomplete anything
(use-package company
  :diminish company-mode
  :config
  (setq company-dabbrev-downcase nil)
  (global-company-mode +1))

;; provide this module
(provide 'init-completion)
