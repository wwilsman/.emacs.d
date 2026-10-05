;;; init-term.el --- Terminal settings and modes -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(setq shell-file-name
      (if (file-exists-p "/usr/bin/fish")
          "/usr/bin/fish"
        "/bin/bash"))

(use-package eat
  :quelpa (eat :fetcher git
               :url "https://codeberg.org/vifon/emacs-eat"
               :branch "fish-integration"
               :files ("*.el" ("term" "term/*.el") "*.texi"
                       "*.ti" ("terminfo/e" "terminfo/e/*")
                       ("terminfo/65" "terminfo/65/*")
                       ("integration" "integration/*")
                       (:exclude ".dir-locals.el" "*-tests.el")))
  :custom
  (eat-term-inside-emacs-ansi-color t)
  (eat-enable-shell-prompt-annotation nil)
  :hook
  (eat-mode . (lambda ()
                (display-line-numbers-mode -1)))
  :config
  (defun ww/eat-rename-buffer-to-title (_terminal title)
    "Rename the current Eat buffer to the terminal TITLE."
    (when (and (derived-mode-p 'eat-mode)
               (not (string-empty-p title)))
      (rename-buffer (format "%s" title) t)))
  (defun ww/eat-install-title-handler (_process)
    "Install the title handler on the current buffer's Eat terminal."
    (when eat-terminal
      (setf (eat-term-parameter eat-terminal 'set-title-function)
            #'ww/eat-rename-buffer-to-title)))
  (add-hook 'eat-exec-hook #'ww/eat-install-title-handler))

(provide 'init-term)
;;; init-term.el ends here
