;;; init-javascript.el --- JS modes
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package js2-mode
  :custom
  (sgml-basic-offset 2)
  (sgml-attribute-offset 0)
  (js-indent-level 2)
  (js-switch-indent-offset 2)
  (js2-basic-offset 2)
  (js2-strict-missing-semi-warning nil)
  (js2-missing-semi-one-line-override t)
  (js2-mode-show-parse-errors nil)
  (js2-mode-show-strict-warnings nil)
  (js2-mode-strict-inconsistent-return-warning nil)
  (js2-getprop-has-side-effects t)
  :config
  (define-key js2-mode-map (kbd "M-.") nil)
  ;; support for private fields
  (advice-add #'js2-identifier-start-p :after-until
              (lambda (c) (eq c ?#))))

(use-package js2-refactor
  :hook ((js2-mode . js2-refactor-mode)
         (web-mode . js2-refactor-mode))
  :config
  (js2r-add-keybindings-with-prefix "C-c C-r"))

(use-package xref-js2
  :hook ((js2-mode . (lambda ()
    (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))))

(use-package rjsx-mode
  :pin melpa
  :mode "\\.jsx?\\'")

(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :custom
  (typescript-indent-level 2))

(use-package lsp-mode
  :hook ((typescript-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands (lsp lsp-deferred))
(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package js-doc
  :bind (:map js2-refactor-mode-map
         ("C-c C-r i d" . js-doc-insert-function-doc)
         ("@" . js-doc-insert-tag))
  :custom
  (js-doc-mail-address "wil@wilwilsman.com")
  (js-doc-author (format "Wil Wilsman <%s>" js-doc-mail-address)))

(use-package add-node-modules-path
  :hook ((js2-mode . add-node-modules-path)
         (web-mode . add-node-modules-path)))

(use-package json-mode)
(use-package prettier-js)

;; parse node stack traces in compilation buffers
(require 'compile)
(add-to-list 'compilation-error-regexp-alist 'node)
(add-to-list 'compilation-error-regexp-alist-alist
             '(node "^[[:blank:]]*at \\(.*(\\|\\)\\(.+?\\):\\([[:digit:]]+\\):\\([[:digit:]]+\\)" 2 3 4))

(provide 'init-javascript)
;;; init-javascript.el ends here
