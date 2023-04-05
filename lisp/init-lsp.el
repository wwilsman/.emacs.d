;;; init-lsp.el --- Language server mode
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((web-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :custom
  (lsp-eslint-package-manager "yarn")
  :config
  (setf (alist-get 'web-mode lsp--formatting-indent-alist) 'web-mode-code-indent-offset)
  (add-to-list 'lsp-language-id-configuration '("\\.hbs?\\'" . "html"))
  (setq lsp-keymap-prefix "C-c l"
        lsp-eldoc-enable-hover nil
        lsp-signature-auto-activate nil
        lsp-enable-on-type-formatting nil
        lsp-headerline-breadcrumb-enable nil
        ;lsp-eslint-server-command '("vscode-eslint-language-server" "--stdio")
        lsp-eslint-validate '("javascript" "javascriptreact")))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-show-code-actions t
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-hover nil
        lsp-ui-doc-enable nil))

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; The paths to lsp-mode and clients needs to be added to load-path
(add-to-list 'load-path (expand-file-name "lib/lsp-mode" user-emacs-directory))
(add-to-list 'load-path (expand-file-name "lib/lsp-mode/clients" user-emacs-directory))

(provide 'init-lsp)
;;; init-lsp.el ends here
