;; default window size
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 40))

;; window margins
(set-window-margins nil nil)

;; shortcuts to maximize the screen
(global-set-key (kbd "<s-return>") 'toggle-frame-maximized)
(global-set-key (kbd "<s-S-return>") 'toggle-frame-fullscreen)

;; Split horizontally when opening a new window from a command
(setq split-height-threshold nil)

(defun ww/adjust-split-width-threshold ()
  (setq split-width-threshold (+ 1 (/ (frame-width) 2))))
(add-hook 'window-configuration-change-hook 'ww/adjust-split-width-threshold)

;; vertical split, switch window, and open next buffer
(defun ww/vsplit-last-buffer ()
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))
(global-set-key (kbd "C-x 2") 'ww/vsplit-last-buffer)

;; horizontal split, switch window, and open next buffer
(defun ww/hsplit-last-buffer ()
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))
(global-set-key (kbd "C-x 3") 'ww/hsplit-last-buffer)

;; provide this module
(provide 'init-window)
