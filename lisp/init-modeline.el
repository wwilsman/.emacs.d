;;; init-modeline.el --- Modeline settings
;;; Commentary:
;;; Code:
(require 'use-package)

;; mode line modes
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(use-package spaceline
  :init
  (defun ww/diff-hl-reducer (acc it)
    "A reducer to count added, removed, and modified lines from diff-hl.
Inserts, deletes, or changes lines in ACC according to IT."
    (cl-destructuring-bind (added removed modified) acc
      (let ((lines (nth 1 it))
            (type (nth 2 it)))
        (pcase type
          ('insert (list (+ added lines) removed modified))
          ('delete (list added (+ removed lines) modified))
          ('change (list added removed (+ modified lines)))))))
  :config
  ;; spaceline-all-the-icons does not come with diff-hl support out of the box so
  ;; we redefine it's git-stat function to gather diff info from diff-hl instead
  ;; of git-gutter.
  (defun spaceline-all-the-icons--git-statistics ()
    "Return a list of added, removed, and modified lines in the current file.
Uses diff-hl as oppose to the default git-gutter functions."
    (cond
     ((bound-and-true-p diff-hl-mode)
      (cl-reduce 'ww/diff-hl-reducer (diff-hl-changes) :initial-value '(0 0 0)))
     (t '(0 0 0)))))

(use-package spaceline-all-the-icons
  :custom
  (spaceline-all-the-icons-separator-type 'arrow)
  :init
  (spaceline-all-the-icons-theme))

(provide 'init-modeline)
;;; init-modeline.el ends here
