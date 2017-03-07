;; mode line modes
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; powerline
(use-package powerline
  :config
  (powerline-default-theme)
  (setq powerline-height 20
        powerline-gui-use-vcs-glyph t
        ns-use-srgb-colorspace nil))

;; provide this module
(provide 'init-modeline)
