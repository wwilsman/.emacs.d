;; mode line modes
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; powerline
(use-package powerline
  :init
  (setq powerline-height 20)
  (setq powerline-gui-use-vcs-glyph t)
  (setq ns-use-srgb-colorspace nil)
  :config
  (powerline-default-theme))

;; provide this module
(provide 'init-modeline)
