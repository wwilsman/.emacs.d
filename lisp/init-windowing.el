;;; init-windowing.el --- Windowing settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

;; shortcuts to maximize the screen
(global-set-key (kbd "<s-return>") 'toggle-frame-maximized)
(global-set-key (kbd "<s-S-return>") 'toggle-frame-fullscreen)

;; use super for switching between visible windows
(windmove-default-keybindings 'super)

(defvar ww/tty-cell-aspect 3.1
  "Assumed terminal character cell aspect ratio.
Used to approximate orientation on a TTY.")

(defun ww/frame-portrait-p ()
  "Non-nil when the selected frame is taller than it is wide.
Graphic frames compare pixels; TTY frames approximate via
`ww/tty-cell-aspect' since `frame-pixel-*' report character cells."
  (if (display-graphic-p)
      (> (frame-pixel-height) (frame-pixel-width))
    (> (* (frame-height) ww/tty-cell-aspect) (frame-width))))

(defun ww/display-buffer-orientation (buffer alist)
  "Display BUFFER based on the selected frame's orientation.
Landscape splits right (or reuses a window if several); portrait
splits below (or replaces the opposite window if several)."
  (if (> (length (window-list)) 1)
      (display-buffer-use-some-window
       buffer (cons '(inhibit-same-window . t) alist))
    (if (ww/frame-portrait-p)
        (display-buffer-below-selected buffer alist)
      (display-buffer-in-direction
       buffer (cons '(direction . right) alist)))))

(setq display-buffer-base-action '(ww/display-buffer-orientation)
      split-height-threshold 30
      split-width-threshold 80)

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
