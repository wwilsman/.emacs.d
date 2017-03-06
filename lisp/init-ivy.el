(use-package ivy
  :diminish ivy-mode
  :config
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t))

(use-package swiper
  :bind (("C-s" . swiper)))

(use-package counsel
  :bind (([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library)))

;; provide this module
(provide 'init-ivy)
