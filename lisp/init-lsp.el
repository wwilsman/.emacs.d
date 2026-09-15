;;; init-lsp.el --- Language server mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((web-mode . lsp-deferred)
         (go-mode . lsp-deferred)
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (setf (alist-get 'web-mode lsp--formatting-indent-alist) 'web-mode-code-indent-offset)
  (add-to-list 'lsp-language-id-configuration '("\\.hbs?\\'" . "html"))
  (add-to-list 'lsp-language-id-configuration '("\\.[mc]?[j]?sx?\\'" . "javascript"))
  (add-to-list 'lsp-language-id-configuration '("\\.ts\\'" . "typescript"))
  (add-to-list 'lsp-language-id-configuration '("\\.tsx\\'" . "typescriptreact"))
  (setq lsp-keymap-prefix "C-c l"
        lsp-auto-guess-root t
        lsp-eldoc-enable-hover nil
        lsp-signature-auto-activate nil
        lsp-enable-on-type-formatting nil
        lsp-headerline-breadcrumb-enable nil
        lsp-apply-edits-after-file-operations nil))
        ;lsp-eslint-validate '("javascript" "javascriptreact")))

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

;; Yarn PnP projects can't resolve LSP server binaries the normal way, so we run them through `yarn
;; dlx'.  A project using the node_modules linker (even while still using yarn) installs those
;; binaries into `node_modules/.bin', so we can invoke them directly.  The presence of a
;; `.pnp.cjs'/`.pnp.js' file at the project root is the definitive signal that PnP is in use.
(defun ww/yarn-pnp-project-p (filename)
  "Return non-nil when FILENAME belongs to a yarn PnP project."
  (or (locate-dominating-file filename ".pnp.cjs")
      (locate-dominating-file filename ".pnp.js")))

(defun ww/node-local-bin (filename binary)
  "Return the path to BINARY in FILENAME's nearest node_modules/.bin, or nil."
  (when-let* ((dir (locate-dominating-file
                    filename
                    (lambda (d) (file-executable-p
                                 (expand-file-name (concat "node_modules/.bin/" binary) d)))))
              (path (expand-file-name (concat "node_modules/.bin/" binary) dir)))
    path))

(defun ww/js-server-command (filename binary dlx-args run-args)
  "Build the LSP command list for BINARY given FILENAME.
Prefer a global executable, then FILENAME's project-local
node_modules/.bin, and finally `yarn dlx' with DLX-ARGS for PnP
projects.  RUN-ARGS are appended to the direct-invocation forms."
  (cond
   ((executable-find binary)
    (cons binary run-args))
   ((ww/node-local-bin filename binary)
    (cons (ww/node-local-bin filename binary) run-args))
   (t
    (append '("yarn" "dlx") dlx-args))))

;; Register JS/TS LSP clients that fall back to yarn only when needed
(with-eval-after-load 'lsp-mode
  ;; TypeScript server.  Only take over from the built-in `ts-ls' when a normal executable can't be
  ;; found; otherwise defer to it.
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       (ww/js-server-command
                        (buffer-file-name)
                        "typescript-language-server"
                        '("-p" "typescript"
                          "-p" "typescript-language-server"
                          "typescript-language-server" "--stdio")
                        '("--stdio"))))
    :activation-fn (lambda (filename &optional _)
                     (and (string-match-p "\\.\\(tsx?\\|jsx?\\)\\'" filename)
                          (not (executable-find "typescript-language-server"))
                          (or (ww/yarn-pnp-project-p filename)
                              (ww/node-local-bin filename "typescript-language-server"))))
    :priority 1
    :major-modes '(web-mode typescript-mode)
    :server-id 'ts-yarn))

  ;; Biome LSP.  lsp-mode has no built-in Biome client, so this is always needed; resolve the binary
  ;; directly when possible, else via yarn dlx.
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-stdio-connection
                     (lambda ()
                       (ww/js-server-command
                        (buffer-file-name)
                        "biome"
                        '("@biomejs/biome" "lsp-proxy")
                        '("lsp-proxy"))))
    :activation-fn (lambda (filename &optional _)
                     (locate-dominating-file filename "biome.json"))
    :major-modes '(web-mode typescript-mode js-mode)
    :server-id 'biome
    :add-on? t)))

(provide 'init-lsp)
;;; init-lsp.el ends here
