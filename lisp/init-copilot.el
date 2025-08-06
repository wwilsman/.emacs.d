;;; init-copilot.el --- GitHub Copilot
;;; Commentary:
;;; Code:
(require 'quelpa-use-package)

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
  :config
  (add-to-list 'copilot-major-mode-alist '("web-mode" . "javascript")))

(provide 'init-copilot)
;;; init-copilot.el ends here
