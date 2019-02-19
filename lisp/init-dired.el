;;; init-dired.el --- Dired settings
;;; Commentary:
;;; Code:
(require 'quelpa-use-package)

(use-package dired+
  :ensure nil ; quelpa will take care of this
  :quelpa (dired+ :fetcher wiki)
  :custom
  (diredp-hide-details-initially-flag nil)
  (diredp-hide-details-propagate-flag nil)
  :config
  (diredp-toggle-find-file-reuse-dir 1)

  (defadvice dired-readin
      (after dired-after-updating-hook first () activate)
    "Sort dired listings with directories first before adding marks."
    (lambda ()
      (save-excursion
        (let (buffer-read-only)
          (forward-line 2) ;; beyond dir. header
          (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
        (set-buffer-modified-p nil)))))

(provide 'init-dired)
;;; init-dired.el ends here
