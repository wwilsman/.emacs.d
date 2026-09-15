;;; init-dired.el --- Dired settings  -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:
(require 'use-package)

(use-package nerd-icons
  :custom
  (nerd-icons-font-family "VictorMono Nerd Font"))

(use-package dirvish
  :after nerd-icons
  :init
  (dirvish-override-dired-mode)
  :custom
  ;; Show git commit messages, file info, and icons
  (dirvish-attributes '(subtree-state vc-state nerd-icons collapse git-msg file-size))
  (dirvish-icon-delimiter "  ")
  (dirvish-mode-line-format '(:left (sort symlink) :right (omit yank index)))
  (dirvish-header-line-format '(:left (path)))
  ;; -A shows dotfiles but hides . and ..
  (dired-listing-switches "-l --almost-all --group-directories-first")
  :config
  ;; macOS ls compatibility
  (when (eq system-type 'darwin)
    (setq ls-lisp-use-insert-directory-program nil)))

;; Load dirvish extensions (bundled with dirvish)
(with-eval-after-load 'dirvish
  (require 'dirvish-subtree nil t)
  (require 'dirvish-fd nil t)
  ;; Dim the subtree guides so gaps are less noticeable
  (with-eval-after-load 'dirvish-subtree
    (set-face-attribute 'dirvish-subtree-guide nil :foreground "#3a3a4a"))
  ;; Smart return key: navigate into projects, toggle subtree for directories, open files otherwise
  (defun ww/dirvish-smart-return ()
    "Navigate into project directories, toggle subtree for regular directories, open regular files."
    (interactive)
    (let ((file (dired-get-filename nil t)))
      (cond
       ;; If it's a directory with .git, navigate into it
       ((and (file-directory-p file)
             (file-exists-p (expand-file-name ".git" file)))
        (dired-find-file))
       ;; If it's a regular directory, toggle subtree
       ((file-directory-p file)
        (dirvish-subtree-toggle))
       ;; Otherwise open the file
       (t (dired-find-file)))))

  ;; Subtree keybindings
  (define-key dirvish-mode-map (kbd "TAB") #'dirvish-subtree-toggle)
  (define-key dirvish-mode-map (kbd "<backtab>") #'dirvish-subtree-remove)
  (define-key dirvish-mode-map (kbd "RET") #'ww/dirvish-smart-return)
  (define-key dirvish-mode-map (kbd "<return>") #'ww/dirvish-smart-return)
  (define-key dirvish-mode-map (kbd "DEL") #'dired-up-directory)
  (define-key dirvish-mode-map (kbd "<backspace>") #'dired-up-directory)

  ;; Fix emoji/ellipsis width calculation in git-msg overlay
  ;;
  ;; Problem: `string-width` returns character-based width which doesn't
  ;; match actual pixel rendering for emojis. This causes overlay positioning
  ;; issues manifesting as line navigation skipping and subtree expansion bugs.
  ;;
  ;; Solution: Use `string-pixel-width` / `frame-char-width` for accurate width.
  ;;
  ;; Upstream fix (for PR):
  ;; 1. Add `dirvish--display-width` helper to dirvish.el
  ;; 2. In `dirvish--render-attrs-1`, change:
  ;;      (let* ((len1 (string-width (or right "")))
  ;;    to:
  ;;      (let* ((len1 (dirvish--display-width right))
  (defun dirvish--display-width (str)
    "Return display width of STR in character columns.
For GUI Emacs, uses pixel-based calculation for accuracy with
variable-width characters (emojis, special symbols).
Uses ceiling to ensure enough space is reserved (fixes navigation)."
    (if (and str (display-graphic-p))
        (let* ((pixel-w (string-pixel-width str))
               (char-w (frame-char-width))
               (cols (ceiling (/ (float pixel-w) char-w))))
          ;; If string contains emojis, use max of pixel-based and string-width
          ;; to handle fonts where emojis render narrower than 2 chars
          (if (string-match-p "[\U0001F300-\U0001F9FF\u2600-\u27BF]" str)
              (max cols (string-width str))
            cols))
      (string-width (or str ""))))

  (defun my/dirvish--render-attrs-1-fixed
      (height width pos remote fns align-to hl w-width)
    "Fixed version using pixel-based width for right-aligned attributes."
    (when (cdr dired-subdir-alist) (goto-char (window-start)))
    (forward-line (- 0 height))
    (cl-dotimes (_ (* 2 height))
      (when (eobp) (cl-return))
      (let ((f-beg (dired-move-to-filename))
            (f-end (dired-move-to-end-of-filename t))
            (l-beg (line-beginning-position)) (l-end (line-end-position))
            (f-wid 0) f-str f-name f-attrs f-type hl-face left right f-line?)
        (setq hl-face (and (eq (or f-beg l-beg) pos) hl))
        (when (setq f-line? (and f-beg f-end (eq (char-after l-end) 10)))
          (setq f-str (buffer-substring f-beg f-end)
                f-wid (string-width f-str)
                f-name (concat (if remote (dired-current-directory)
                                 (file-local-name (dired-current-directory)))
                               f-str)
                f-attrs (dirvish-attribute-cache f-name :builtin
                          (unless remote (ignore-errors (file-attributes f-name))))
                f-type (dirvish-attribute-cache f-name :type
                         (let ((ch (progn (back-to-indentation) (char-after))))
                           (cond
                            (remote `(,(if (eq ch 100) 'dir 'file) . nil))
                            ((eq ch 100) '(dir . nil))
                            ((eq ch 108)
                             `(,(if (file-directory-p f-name) 'dir 'file) .
                               ,(buffer-substring (+ f-end 4) l-end)))
                            (t '(file . nil))))))
          (unless (get-text-property f-beg 'mouse-face)
            (dired-insert-set-properties l-beg l-end)))
        (cl-loop
         for fn in (if f-line? fns '(dirvish-attribute-hl-line-rd))
         for (k . v) = (funcall fn f-beg f-end f-str f-name
                                f-attrs f-type l-beg l-end hl-face w-width)
         do (pcase k ('ov (overlay-put v 'dirvish-a-ov t))
                   ('ovs (dolist (ov v) (overlay-put ov 'dirvish-a-ov t)))
                   ('left (setq left (concat v left)))
                   ('right (setq right (concat v right))))
         finally
         (prog1 (unless (or left right) (cl-return))
           ;; FIX: Use pixel-based width for accurate emoji/ellipsis handling
           (let* ((len1 (dirvish--display-width right))
                  ;; Calculate pixel difference for precise padding
                  (right-str (or right ""))
                  (reserved-px (* len1 (frame-char-width)))
                  (actual-px (if (display-graphic-p)
                                 (string-pixel-width right-str)
                               reserved-px))
                  (pad-px (max 0 (- reserved-px actual-px)))
                  ;; Create pixel-precise padding using display property
                  (right-padded (if (and (display-graphic-p) (> pad-px 0))
                                    (concat (propertize " " 'display `(space :width (,pad-px)) 'face hl-face) right-str)
                                  right-str))
                  (remain (- width len1
                             (or (get-text-property l-beg 'line-prefix) 0)))
                  (len2 (min (length left) (max 0 (- remain f-wid 1))))
                  (ovl (make-overlay f-end f-end))
                  (r-pos (if (> remain f-wid) l-end
                           (let ((end (+ f-beg remain))
                                 (offset (- f-wid (length f-str))))
                             (- end offset))))
                  (spec `(space :align-to (- right-fringe ,len1 ,align-to)))
                  (spc (propertize " " 'display spec 'face hl-face))
                  (ovr (make-overlay r-pos r-pos)))
             (overlay-put ovl 'dirvish-l-ov t)
             (overlay-put ovl 'after-string (substring (or left "") 0 len2))
             (overlay-put ovr 'dirvish-r-ov t)
             (overlay-put ovr 'after-string (concat spc right-padded))))))
      (forward-line 1)))

  (advice-add 'dirvish--render-attrs-1 :override #'my/dirvish--render-attrs-1-fixed))

;; Show branch name instead of a commit message for git worktrees.
;;
;; Problem: With a worktree layout (e.g. ~/code/glow/gs-ghost/ holding the
;; main .git and per-branch worktree subdirs), dirvish's git-msg fetch runs
;; `git log -1 --pretty=%s <subdir>` from the parent repo. Git rejects a
;; linked worktree path as "outside repository", so the fatal error string is
;; displayed as the commit message.
;;
;; Solution: Override `dirvish-data-for-dir' so that any subdir with its own
;; `.git` (a linked worktree or nested repo) shows its branch name via
;; `git -C <dir> symbolic-ref`, falling back to a short SHA for detached HEAD.
;; Everything else keeps the upstream `git log` behavior.
(with-eval-after-load 'dirvish-vc
  (cl-defmethod dirvish-data-for-dir
    (dir buffer inhibit-setup
         &context ((dirvish-prop :vc-backend) symbol)
         &context ((dirvish-prop :remote) symbol))
    "Fetch data for DIR in BUFFER (worktree-aware git-msg override).
Behaves like the upstream method but shows the branch name for
subdirectories that are their own git worktree/repo."
    (dirvish--make-proc
     `(prin1
       (let* ((hs (make-hash-table))
              (bk ',(dirvish-prop :vc-backend))
              (info (vc-call-backend bk 'mode-line-string ,dir)))
         (advice-add #'vc-git--git-status-to-vc-state :around
                     (lambda (fn codes) (apply fn (list (delete-dups codes)))))
         (dolist (file (directory-files ,dir t nil t))
           (let ((state (if (string-suffix-p ,dirvish-vc--always-ignored file)
                            'ignored (vc-state-refresh file bk)))
                 (msg (and (eq bk 'Git)
                           (if (file-exists-p (expand-file-name ".git" file))
                               ;; Worktree / nested repo: show branch name.
                               (let ((br (string-trim
                                          (shell-command-to-string
                                           (format "git -C %s symbolic-ref --short HEAD 2>/dev/null"
                                                   (shell-quote-argument file))))))
                                 (concat
                                  (if (> (length br) 0)
                                      br
                                    ;; Detached HEAD: fall back to short SHA.
                                    (string-trim
                                     (shell-command-to-string
                                      (format "git -C %s rev-parse --short HEAD 2>/dev/null"
                                              (shell-quote-argument file)))))
                                  "\n"))
                             ;; Suppress stderr so files git can't handle
                             ;; (untracked/outside paths like .git, .claude)
                             ;; show nothing instead of a fatal error.
                             (shell-command-to-string
                              (format "git log -1 --pretty=%%s %s 2>/dev/null"
                                      (shell-quote-argument file)))))))
             (puthash (secure-hash 'md5 file)
                      `(:vc-state ,state :git-msg ,msg) hs)))
         (cons info hs)))
     (lambda (p _)
       (pcase-let ((`(,buf . ,inhibit-setup) (process-get p 'meta))
                   (`(,info . ,data) (with-current-buffer (process-buffer p)
                                       (read (buffer-string)))))
         (when (buffer-live-p buf)
           (with-current-buffer buf
             (maphash
              (lambda (k v)
                (let ((orig (gethash k dirvish--dir-data)))
                  (setf (plist-get orig :vc-state) (plist-get v :vc-state))
                  (setf (plist-get orig :git-msg) (plist-get v :git-msg))
                  (puthash k orig dirvish--dir-data)))
              data)
             (dirvish-prop :vc-info info)
             (unless inhibit-setup (run-hooks 'dirvish-setup-hook))
             (dirvish--redisplay))))
       (delete-process p)
       (dirvish--kill-buffer (process-buffer p)))
     nil 'meta (cons buffer inhibit-setup))))

(provide 'init-dired)
;;; init-dired.el ends here
