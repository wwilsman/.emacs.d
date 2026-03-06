;;; init-ai.el --- AI integrations -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'quelpa-use-package)

(when (file-directory-p (expand-file-name ".local/copilot" user-emacs-directory))
  (use-package copilot
    :ensure nil ; quelpa will take care of this
    :quelpa (copilot :fetcher github
                     :repo "copilot-emacs/copilot.el"
                     :branch "main"
                     :files ("*.el"))
    :hook (prog-mode . copilot-mode)
    :bind (:map copilot-completion-map
                ("TAB" . 'copilot-accept-completion)
                ("RET" . 'copilot-accept-completion)
                ("<tab>" . 'copilot-accept-completion)
                ("<ret>" . 'copilot-accept-completion)
                ("C-TAB" . 'copilot-accept-completion-by-word)
                ("C-RET" . 'copilot-accept-completion-by-word)
                ("C-<tab>" . 'copilot-accept-completion-by-word)
                ("C-<ret>" . 'copilot-accept-completion-by-word))
    :custom
    (copilot-indent-offset-warning-disable t)
    :config
    (add-to-list 'copilot-major-mode-alist '("web-mode" . "javascript"))))

(use-package claudemacs
  :quelpa (claudemacs :fetcher github
                      :repo "cpoile/claudemacs"
                      :branch "main"
                      :files ("*.el"))
  :bind ("C-c C-'" . claudemacs-transient-menu))

(provide 'init-ai)
;;; init-ai.el ends here
