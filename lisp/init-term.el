;;; init-term.el --- Terminal settings and modes
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package multi-term
  :custom
  (multi-term-program "/bin/zsh")
  (term-suppress-hard-newline t)
  :config
  (add-hook
   'term-mode-hook
   (lambda ()
     (define-key term-raw-map (kbd "C-z") 'self-insert-command)))
  (defun projectile-run-term ()
    "Get dedicated multi-term in project root"
    (interactive)
    (setq projectile--proj-term-name
          (concat "*" multi-term-buffer-name "<" (projectile-project-name) ">*"))
    (if (not (eq nil (get-buffer projectile--proj-term-name)))
        (switch-to-buffer projectile--proj-term-name)
      (projectile-with-default-dir (projectile-project-root)
        (multi-term)
        (rename-buffer projectile--proj-term-name)))))

(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

(setq shell-file-name "/bin/zsh")

(provide 'init-term)
;;; init-term.el ends here
