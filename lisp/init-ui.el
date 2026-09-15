;;; init-ui.el --- UI settings -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(setq-default tab-width 2)

(setq inhibit-startup-screen t
      max-mini-window-height 0.3)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)
(set-window-margins nil nil)
(fringe-mode `(2 . 8))

(setq window-divider-default-right-width 24
      window-divider-default-places 'right-only)
(add-to-list 'default-frame-alist '(internal-border-width . 24))
(window-divider-mode 1)

(setq widget-image-enable nil
      org-hide-emphasis-markers t)

;; Enable mouse support and when running in terminal
(unless (display-graphic-p)
  (xterm-mouse-mode 1))

;; Line numbers
(setq display-line-numbers-width-start t)
(global-display-line-numbers-mode t)

;; auto update terminal title
(defun ww/terminal-set-title ()
  "Update the terminal tab title with a shrunk path, matching the shell logic."
  (when (not (window-system))
    (let* ((full-path (abbreviate-file-name default-directory))
           (parts (split-string full-path "/" t))
           (len (length parts))
           (shrunk-path "")
           (buf-name (if (buffer-file-name)
                         (file-name-nondirectory (buffer-file-name))
                       (buffer-name))))

      (setq shrunk-path
            (mapconcat
             (lambda (part)
               (let ((idx (cl-member part parts :test 'string=)))
                 (if (<= (length idx) 2)
                     part
                   (if (string= part "") "" (substring part 0 1)))))
             parts "/"))

      (let* ((clean-path (directory-file-name shrunk-path))
             (final-title (format "%s [%s]" buf-name clean-path)))
        (send-string-to-terminal (format "\e]0;%s\a" final-title))))))
(add-hook 'post-command-hook 'ww/terminal-set-title)

(provide 'init-ui)
;;; init-ui.el ends here
