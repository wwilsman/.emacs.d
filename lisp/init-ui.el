;;; init-ui.el --- UI settings
;;; Commentary:
;;; Code:
(setq-default tab-width 2)

(setq inhibit-startup-screen t
      max-mini-window-height 0.3)

(menu-bar-mode -1)
(blink-cursor-mode -1)
(set-window-margins nil nil)

(setq window-divider-default-right-width 24
      window-divider-default-places 'right-only)
(add-to-list 'default-frame-alist '(internal-border-width . 24))
(window-divider-mode 1)

(setq widget-image-enable nil
      org-hide-emphasis-markers t)

(when (display-graphic-p)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (fringe-mode `(2 . 8)))

(provide 'init-ui)
;;; init-ui.el ends here
