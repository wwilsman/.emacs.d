;;; init-minibuffer.el --- Initialize minibuffer
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

;; floating minibuffer
(use-package mini-frame
  :defer nil
  :custom
  (mini-frame-show-parameters `(
    (top . 100)
    (left . 0.5)
    (width . 0.5)
    (alpha . 0.9)
    (left-fringe . 13)
    (right-fringe . 13)
    (internal-border-width . 0)
    (child-frame-border-width . 1)))
  (mini-frame-ignore-commands '("edebug-eval-expression" debugger-eval-expression))
  :init
  (defun ww/minibuffer-setup ()
    (setq line-spacing 0.4)
    (face-remap-add-relative 'default 'highlight)
    (face-remap-add-relative 'fringe 'default)
    (let ((overlay (make-overlay (point-min) (+ (point-min) 1)))
          (space (propertize "\n" 'face '(:height 0.5))))
      (overlay-put overlay 'before-string space)))
  :hook
  (minibuffer-setup . ww/minibuffer-setup)
  :config
  (mini-frame-mode 1))

(provide 'init-minibuffer)
;;; init-minibuffer.el ends here
