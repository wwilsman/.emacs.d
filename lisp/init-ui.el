;;; init-ui.el --- UI settings
;;; Commentary:
;;; Code:
(require 'util)

(setq-default tab-width 2)

(setq inhibit-startup-screen t
      max-mini-window-height 0.3)

(menu-bar-mode -1)
(blink-cursor-mode -1)
(set-window-margins nil nil)

(ww/after-daemon-frame
 (lambda ()
   (when (display-graphic-p)
     (tool-bar-mode -1)
     (scroll-bar-mode -1)
     (fringe-mode `(2 . 8)))))

(provide 'init-ui)
;;; init-ui.el ends here
