;; projectile
(use-package projectile
  :diminish projectile-mode
  :config
  (setq projectile-completion-system 'ivy)
  (projectile-global-mode))

;; projectile ivy overrides
(use-package counsel-projectile
  :config
  (counsel-projectile-on))

;; provide this module
(provide 'init-projects)
