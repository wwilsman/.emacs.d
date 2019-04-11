;;; init-editing.el --- Editing utils
;;; Commentary:
;;; Code:
(require 'use-package)

;; spaces > tabs
(setq-default indent-tabs-mode nil
              tab-always-indent 'complete
              tab-width 2)

;; default fill-column
(setq-default fill-column 80)

;; show trailing whitespace in prog-mode
(add-hook 'prog-mode-hook (lambda () (setq show-trailing-whitespace t)))

;; missing newlines can mess up diffs
(setq require-final-newline t)

;; silence!
(setq ring-bell-function 'ignore)

;; some packages modify key-bindings themselves and produce noisy messages
(setq ad-redefinition-action 'accept)

;; temp file locations
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; prevent lockfiles
(setq create-lockfiles nil)

;; auto revert
(global-auto-revert-mode t)
(diminish 'auto-revert-mode)

;; y/n prompts
(fset 'yes-or-no-p 'y-or-n-p)

;; delete selections
(delete-selection-mode t)

;; scroll one line at a time
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1
      mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't
      scroll-step 1)

;; autosave buffers with names
(defadvice switch-to-buffer (before save-buffer-now activate)
  "Autosave file on buffer switch."
  (when buffer-file-name (save-buffer)))
(defadvice other-window (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-up (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-down (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-left (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
(defadvice windmove-right (before other-window-now activate)
  "Autosave file on window switch."
  (when buffer-file-name (save-buffer)))
;; autosave when focus is lost
(add-hook 'focus-out-hook (lambda () (when buffer-file-name (save-buffer))))

;; key-chords
(use-package use-package-chords
  :config (key-chord-mode 1))

;; jump anywhere
(use-package ace-jump-mode
  :chords (("jj" . ace-jump-char-mode)
           ("jk" . ace-jump-word-mode)
           ("jl" . ace-jump-line-mode)))

;; ridiculously useful extenstions
(use-package crux
  :bind (([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c d" . crux-duplicate-current-line-or-region)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c M-d" . crux-duplicate-and-comment-current-line-or-region)
         ("C-c r" . crux-rename-file-and-buffer)
         :map window-swap-map
         ("s" . crux-transpose-windows))
  :chords (("JJ" . crux-switch-to-previous-buffer))
  :config
  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify))

;; ability to restart emacs quickly
(use-package restart-emacs)

;; auto open/close pairs
(use-package smartparens-config
  :ensure smartparens
  :diminish smartparens-mode
  :config
  (smartparens-global-mode 1))

;; useful to browse kill-ring
(use-package browse-kill-ring
  :chords (("yy" . browse-kill-ring)))

;; undo-tree
(use-package undo-tree
  :diminish undo-tree-mode
  :chords (("uu" . undo-tree-visualize))
  :custom
  (undo-tree-history-directory-alist `((".*" . ,temporary-file-directory)))
  (undo-tree-auto-save-history t)
  :config
  (global-undo-tree-mode))

;; which key
(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode t))

(use-package yasnippet
  :config
  (yas-global-mode t))

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
(use-package move-text
  :bind (("M-p" . move-text-up)
         ("M-n" . move-text-down)))

;; smart trim whitespace
(use-package whitespace-cleanup-mode
  :diminish whitespace-cleanup-mode
  :hook (after-init . global-whitespace-cleanup-mode))

;; auto-detect indentation
(use-package dtrt-indent
  :diminish dtrt-indent-mode
  :config
  (dtrt-indent-mode t))

(provide 'init-editing)
;;; init-editing.el ends here
