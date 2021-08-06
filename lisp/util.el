;; -*- lexical-binding: t -*-
;;; util.el --- Custom Emacs utilities
;;; Commentary:
;;; Code:

;; helper for registering frame-based config
(defun ww/after-daemon-frame (func)
  "When not running as a daemon, invoke FUNC, otherwise add it to `after-make-frame-functions'."
  (if (not (daemonp))
      (funcall func)
     (add-hook
      'after-make-frame-functions
      (lambda (frame)
        (select-frame frame)
        (funcall func)))))

(provide 'util)
;;; util.el ends here
