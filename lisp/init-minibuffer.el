;;; init-minibuffer.el --- Completion packages
;;; Commentary:
;;; Code:
(require 'use-package)

;; ivy and friends
(use-package ag)
(use-package flx)
(use-package smex)
(use-package ivy
  :diminish ivy-mode
  :custom
  (ivy-use-virtual-buffers t)
  :config
  (setcdr (assoc t ivy-format-functions-alist) #'ivy-format-function-line)
  (set-face 'ivy-current-match 'nano-face-strong)
  (set-face-attribute 'ivy-current-match nil
                      :extend t
                      :foreground nano-color-background
                      :background nano-color-salient)
  (ivy-mode t))

;; ivy-enhanced commands
(use-package counsel
  :bind (([remap find-file] . counsel-find-file)
         ([remap describe-function] . counsel-describe-function)
         ([remap describe-variable] . counsel-describe-variable)
         ([remap find-library] . counsel-find-library)
         ([remap execute-extended-command] . counsel-M-x)
         ("C-c u" . counsel-unicode-char))
  :bind* (:map counsel-find-file-map
          ([remap ivy-done] . ivy-alt-done))
  :chords (("xx" . counsel-M-x)))

;; ivy search
(use-package swiper
  :bind (("C-s" . swiper)))

;; autocomplete with company
(use-package company
  :diminish company-mode
  :custom
  (company-dabbrev-downcase nil)
  (company-minimum-prefix-length 2)
  (company-tooltip-flip-when-above t)
  :hook (after-init . global-company-mode))

(use-package mini-frame
  :defer nil
  :custom
  (mini-frame-show-parameters `((left . 0.5)
                                (top . 1.0)
                                (width . 1.0)
                                (height . 13)
                                (left-fringe . 16)
                                (right-fringe . 16)
                                (child-frame-border-width . 0)
                                (internal-border-width . 0)
                                (foreground-color . ,nano-color-foreground)
                                (background-color . ,nano-color-subtle)))
  (mini-frame-internal-border-color nano-color-faded)
  (mini-frame-ignore-commands '("edebug-eval-expression" debugger-eval-expression))
  (mini-frame-resize 'not-set)
  :init
  (defun ww/minibuffer-spacing ()
    (setq line-spacing 2)
    (overlay-put (make-overlay (point-min) (+ (point-min) 1))
                  'before-string
                  (propertize "\n" 'face `(:extend t :height 0.7))))
  (with-current-buffer (get-buffer " *Echo Area 0*") (ww/minibuffer-spacing))
  :hook
  (minibuffer-setup . ww/minibuffer-spacing)
  :config
  (mini-frame-mode 1))

(provide 'init-minibuffer)
;;; init-minibuffer.el ends here
