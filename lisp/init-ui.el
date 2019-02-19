;;; init-ui.el --- UI settings
;;; Commentary:
;;; Code:

(setq-default line-spacing 0.625
              tab-width 2)

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(set-window-margins nil nil)
(fringe-mode `(2 . 8))

(provide 'init-ui)
;;; init-ui.el ends here
