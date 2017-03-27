;; code searching
(use-package ag)

;; completion frontend & search
(use-package swiper
  :diminish ivy-mode
  :bind (([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library)
         ([remap execute-extended-command] . counsel-M-x)
         :map counsel-find-file-map
         ([remap ivy-done] . ivy-alt-done))
  :init
  (setq ivy-use-virtual-buffers t)
  :config
  (ivy-mode t))

;; autocomplete anything
(use-package company
  :diminish company-mode
  :init
  (setq company-dabbrev-downcase nil)
  :config
  (global-company-mode +1))

;; provide this module
(provide 'init-completion)
