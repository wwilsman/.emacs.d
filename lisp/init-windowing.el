;;; init-windowing.el --- Windowing settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

;; shortcuts to maximize the screen
(global-set-key (kbd "<s-return>") 'toggle-frame-maximized)
(global-set-key (kbd "<s-S-return>") 'toggle-frame-fullscreen)

;; use super for switching between visible windows
(windmove-default-keybindings 'super)

;; better sensible window splitting
(defun ww/split-window-sensibly (&optional window)
  "Replacement `split-window-sensibly' which prefers vertical splits for WINDOW."
  (interactive)
  (let ((window (or window (selected-window))))
    (or (and (window-splittable-p window t)
             (with-selected-window window (split-window-right)))
        (and (window-splittable-p window)
             (with-selected-window window (split-window-below))))))

(setq split-window-preferred-function #'ww/split-window-sensibly
      split-height-threshold 100
      split-width-threshold 180)

;; use custom vertical split function
(defun ww/v-split-last-buffer ()
  "Vertical split, switch window, and open the next buffer."
  (interactive)
  (split-window-vertically)
  (other-window 1 nil)
  (switch-to-next-buffer))
(global-set-key (kbd "C-x 3") 'ww/v-split-last-buffer)

;; use custom horizontal split function
(defun ww/hsplit-last-buffer ()
  "Horizontal split, switch window, and open the next buffer."
  (interactive)
  (split-window-horizontally)
  (other-window 1 nil)
  (switch-to-next-buffer))
(global-set-key (kbd "C-x 2") 'ww/hsplit-last-buffer)

;; swap split window orientation
(defun ww/swap-split-window-orientation ()
  "Swaps between horizontally split windows and vertically split windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; setup swap keybindings to need a prefix; crux will bind
;; crux-transpose-windows to "s" within this keymap
(define-prefix-command 'window-swap-map)
(global-set-key (kbd "C-c s") 'window-swap-map)
(define-key 'window-swap-map "o" 'ww/swap-split-window-orientation)

(use-package ace-window
  :bind ("M-o" . ace-window))

(provide 'init-windowing)
;;; init-windowing.el ends here
