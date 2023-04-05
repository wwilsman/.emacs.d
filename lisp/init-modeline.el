;;; init-modeline.el --- Completion packages
;;; Commentary:
;;; Code:
(require 'use-package)

;; modeline faces can be customized by the theme
(defface ww/modeline-default-face
  '((t :box (:line-width 1)))
  "Modeline default face"
  :group 'ww)
(defface ww/modeline-strong-face
  '((t :weight bold :inherit ww/modeline-default-face))
  "Modeline strong face"
  :group 'ww)
(defface ww/modeline-popout-face
  '((t :inherit ww/modeline-default-face))
  "Modeline popout face"
  :group 'ww)
(defface ww/modeline-critical-face
  '((t :inherit ww/modeline-default-face))
  "Modeline critical face"
  :group 'ww)
(defface ww/modeline-faded-face
  '((t :weight light :inherit ww/modeline-default-face))
  "Modeline faded face"
  :group 'ww)

;; compose a modeline string spanning the window width
(defun ww/modeline-compose (status name primary secondary)
  "Compose a modeline string consisting of STATUS, NAME, PRIMARY, and SECONDARY."
  (let* ((char-width (window-font-width nil 'header-line))
         (window (get-buffer-window (current-buffer)))         (space-up +0.3)
         (space-down -0.4)
         (prefix (propertize (concat " " status " ") 'face (cond
           ((string= status "**") 'ww/modeline-critical-face)
           ((string= status "RW") 'ww/modeline-faded-face)
           ((string= status "RO") 'ww/modeline-popout-face)
           (t 'ww/modeline-popout-face))))
         (left (concat
           (propertize " "  'face 'ww/modeline-default-face 'display `(raise ,space-up))
           (propertize name 'face 'ww/modeline-strong-face)
           (propertize " "  'face 'ww/modeline-default-face 'display `(raise ,space-down))
           (propertize primary 'face 'ww/modeline-default-face)))
         (right (concat secondary " "))
         (available-width (max 1 (- (window-total-width)
           (length prefix) (length left) (length right)
           (/ (window-right-divider-width) char-width)))))
    (concat prefix left
     (propertize (make-string available-width ?\ ) 'face 'ww/modeline-default-face)
     (propertize right 'face 'ww/modeline-faded-face))))

;; various helpers for getting and displaying modeline information
(defun ww/modeline-status ()
  "Return buffer status: read-only (RO), modified (**) or read-write (RW)."
  (cond ((and buffer-file-name (buffer-modified-p)) "**")
    (buffer-read-only "RO")
    (t "RW")))
(defun ww/mode-name ()
  "Return the current buffer mode name."
  (if (listp mode-name) (car mode-name) mode-name))
(defun ww/vc-branch ()
  "Return the current vc branch name for the project."
  (if (not vc-mode) nil
    (concat "git:" (substring-no-properties
      vc-mode (+ (if (eq (vc-backend buffer-file-name) 'Hg) 2 3) 2)))))
(defun ww/shorten-dir (dir max-length)
  "Show up to MAX-LENGTH characters of directory DIR."
  (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
        (output ""))
    (when (and path (equal "" (car path)))
      (setq path (cdr path)))
    (while (and path (< (length output) (- max-length 4)))
      (setq output (concat (car path) "/" output))
      (setq path (cdr path)))
    (when path
      (setq output (concat "…/" output)))
    output))

;; alternate modeline modes
(defun ww/modeline-term-mode-p ()
  "Return non-nil if the current mode is term-mode."
  (or (derived-mode-p 'term-mode) (derived-mode-p 'vterm-mode)))
(defun ww/modeline-term-mode ()
  "Terminal mode modeline."
  (ww/modeline-compose ">_" "Terminal"
    (concat "(" shell-file-name ")")
    (ww/shorten-dir default-directory 32)))
(defun ww/modeline-default-mode ()
  "Default modeline."
    (ww/modeline-compose
      (ww/modeline-status)
      (format-mode-line "%b")
      (concat "(" (ww/mode-name)
        (let ((branch (ww/vc-branch)))
          (if branch (concat ", " (propertize branch 'face 'italic))))
        ")" )
      (format-mode-line "%l:%c")))

;; modeline hooks
(defun ww/menu-mode-header-line ()
  "Customize the buffer menu header line."
  (face-remap-add-relative
   'header-line `(:background ,(face-background 'default))))
(add-hook 'Buffer-menu-mode-hook #'ww/menu-mode-header-line)

(defun ww/modeline-update-windows ()
  "Modify the mode line depending on the presence of a window
below or a buffer local variable 'no-mode-line'."
  (dolist (window (window-list))
    (with-selected-window window
      (with-current-buffer (window-buffer window)
        (if (or (not (boundp 'no-mode-line)) (not no-mode-line))
          (set-window-parameter window 'mode-line-format
            (cond ((not mode-line-format) 'none)
                  ((one-window-p t 'visible) (list ""))
                  ((eq (window-in-direction 'below) (minibuffer-window)) (list ""))
                  ((not (window-in-direction 'below)) (list ""))
                  (t 'none))))))))
(add-hook 'window-configuration-change-hook 'ww/modeline-update-windows)

;; hide the real modeline
(setq-default mode-line-format (list ""))

;; create a header modeline based on the current mode
(setq-default header-line-format '((:eval (cond
  ((ww/modeline-term-mode-p) (ww/modeline-term-mode))
  (t (ww/modeline-default-mode))))))

(provide 'init-modeline)
;;; init-modeline.el ends here
