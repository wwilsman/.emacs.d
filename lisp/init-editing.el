;; spaces > tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent 'complete)
(setq-default tab-width 2)

;; default fill-column
(setq-default fill-column 80)

;; newlines look nice
(setq require-final-newline t)

;; silence!
(setq ring-bell-function 'ignore)
(setq inhibit-startup-screen t)

;; auto revert
(global-auto-revert-mode t)
(diminish 'auto-revert-mode)

;; y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; delete selections
(delete-selection-mode t)

;; scroll one line at a time
(setq scroll-margin 0)
(setq scroll-conservatively 100000)
(setq scroll-preserve-screen-position 1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))
(setq mouse-wheel-progressive-speed nil)
(setq mouse-wheel-follow-mouse 't)
(setq scroll-step 1)

;; autosave
(setq auto-save-visited-file-name t)
(setq auto-save-interval 20)
(setq auto-save-timeout 5)

(auto-save-mode t)

;; tmp locations
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; prevent lockfiles
(setq create-lockfiles nil)

;; ridiculously useful extenstions
(use-package crux
  :bind (([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-file-and-buffer)
         ("C-c s" . crux-transpose-windows)))

;; useful to browse kill-ring
(use-package browse-kill-ring
  :bind (("M-y" . browse-kill-ring)))

;; undo-tree
(use-package undo-tree
  :diminish undo-tree-mode
  :init
  (setq undo-tree-history-directory-alist `((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t)
  :config
  (global-undo-tree-mode))

;; which key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode +1))

;; highlight changes
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config
  (volatile-highlights-mode t))

;; multiple cursors
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; move lines
(use-package move-lines
  :ensure nil
  :load-path "site-lisp/"
  :config
  (move-lines-binding))

;; smart trim whitespace
(use-package ws-trim
  :ensure nil
  :load-path "site-lisp/"
  :diminish ws-trim-mode
  :init
  (setq ws-trim-level 1)
  :config
  (global-ws-trim-mode +1))

;; provide this module
(provide 'init-editing)
