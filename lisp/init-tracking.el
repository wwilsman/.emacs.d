;;; init-tracking.el --- Tracking stats
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package git-time-metric
  :hook (after-save . git-time-metric-record))

(provide 'init-tracking)
;;; init-tracking.el ends here
