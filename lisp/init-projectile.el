;;; init-projectile.el --- Projectile
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package projectile
  :diminish projectile-mode
  :custom
  (projectile-completion-system 'ivy)
  :config
  (projectile-mode t)
  (projectile-global-mode))

;; projectile ivy overrides
(use-package counsel-projectile
  :bind (:map projectile-mode-map
         ("s-p" . projectile-command-map)
         ("C-c p" . projectile-command-map))
  :config
  (counsel-projectile-mode t))

(provide 'init-projectile)
;;; init-projectile.el ends here
