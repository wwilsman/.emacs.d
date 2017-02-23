;; default window size
(add-to-list 'default-frame-alist '(width . 120))
(add-to-list 'default-frame-alist '(height . 40))

;; window margins
(set-window-margins nil nil)

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
