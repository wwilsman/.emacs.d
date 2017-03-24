(use-package ag)

(use-package swiper
  :diminish ivy-mode
  :bind (("C-s" . swiper)
         ([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library))
  :init
  (ivy-mode t)
  (setq ivy-use-virtual-buffers t))

(use-package counsel-projectile
  :init
  (counsel-projectile-on))

;; provide this module
(provide 'init-ivy)
