;;; init-term.el --- Terminal settings and modes
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package multi-term
  :custom
  (multi-term-program "/bin/zsh")
  (term-suppress-hard-newline t)
  :config
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

(provide 'init-term)
;;; init-term.el ends here
