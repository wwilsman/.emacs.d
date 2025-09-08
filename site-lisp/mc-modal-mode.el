;;; mc-modal-mode.el --- Multiple cursors modal mode. -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(defun disable-mcmm (&rest args)
  "Disable mc-modal-mode - ARGS is unused."
  (mc-modal-mode -1))

;;;###autoload
(define-minor-mode mc-modal-mode
  "mc-modal-mode is a minor mode for multiple cursors key
bindings. The mode is automatically disabled before buffer
changes are made.

Key bindings:
\\{mc-modal-mode-map}"
  :init-value nil
  :lighter " mcmm"
  :keymap
  `((,(kbd "ESC") . mc-modal-mode)
    (,(kbd "C-g") . mc-modal-mode)
    (,(kbd "cc") . mc/edit-lines)
    (,(kbd ".") . mc/mark-next-like-this)
    (,(kbd ",") . mc/mark-previous-like-this)
    (,(kbd "<") . mc/mark-all-like-this))
  :group 'mcmm-group
  (if mc-modal-mode
      (progn
        (add-hook 'before-change-functions #'disable-mcmm nil 'local)
        (message "mc-modal-mode enabled"))
    (progn
      (remove-hook 'before-change-functions #'disable-mcmm 'local)
      (message "mc-modal-mode disabled"))))

(provide 'mc-modal-mode)
;;; mc-modal-mode.el ends here
