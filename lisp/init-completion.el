;;; init-completion.el --- Completion packages
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
(use-package swiper)

;; autocomplete with company
(use-package company
  :diminish company-mode
  :custom
  (company-dabbrev-downcase nil)
  (company-idle-delay 0.5)
  (company-tooltip-limit)
  (company-minimum-prefix-length 2)
  (company-tooltip-flip-when-above t)
  :config
  (global-company-mode t))

(provide 'init-completion)
;;; init-completion.el ends here
