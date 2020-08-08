;;; gitmoji.el --- Gitmoji selector.
;;; Commentary:
;;; Code:

(defvar gitmojis-list
  '(("Improve structure / format of the code." ":art:" #x1F3A8)
    ("Improve performance." ":zap:" #x26A1)
    ("Remove code or files." ":fire:" #x1F525)
    ("Fix a bug." ":bug:" #x1F41B)
    ("Critical hotfix." ":ambulance:" #x1F691)
    ("Introduce new features." ":sparkles:" #x2728)
    ("Write docs." ":pencil:" #x1F4DD)
    ("Deploy stuff." ":rocket:" #x1F680)
    ("Add or update the UI and style files." ":lipstick:" #x1F484)
    ("Begin a project." ":tada:" #x1F389)
    ("Add or update tests." ":white_check_mark:" #x2705)
    ("Fix security issues." ":lock:" #x1F512)
    ("Release / Version tags." ":bookmark:" #x1F516)
    ("Remove linter warnings." ":rotating_light:" #x1F6A8)
    ("Work in progress." ":construction:" #x1F6A7)
    ("Fix CI Build." ":green_heart:" #x1F49A)
    ("Downgrade dependencies." ":arrow_down:" #x2B07)
    ("Upgrade dependencies." ":arrow_up:" #x2B06)
    ("Pin dependencies to specific versions." ":pushpin:" #x1F4CC)
    ("Add or update CI build system." ":construction_worker:" #x1F477)
    ("Add or update analytics or track code." ":chart_with_upwards_trend:" #x1F4C8)
    ("Refactor code." ":recycle:" #x267B)
    ("Add a dependency." ":heavy_plus_sign:" #x2795)
    ("Remove a dependency." ":heavy_minus_sign:" #x2796)
    ("Add or update configuration files." ":wrench:" #x1F527)
    ("Add or update build scripts." ":hammer:" #x1F528)
    ("Internationalization and localization." ":globe_with_meridians:" #x1F310)
    ("Fix typos." ":pencil2:" #x270F)
    ("Write bad code that needs to be improved." ":poop:" #x1F4A9)
    ("Revert changes." ":rewind:" #x23EA)
    ("Merge branches." ":twisted_rightwards_arrows:" #x1F500)
    ("Add or update compiled files or packages." ":package:" #x1F4E6)
    ("Update code due to external API changes." ":alien:" #x1F47D)
    ("Move or rename files." ":truck:" #x1F69A)
    ("Add or update license." ":page_facing_up:" #x1F4C4)
    ("Introduce breaking changes." ":boom:" #x1F4A5)
    ("Add or update assets." ":bento:" #x1F371)
    ("Improve accessibility." ":wheelchair:" #x267F)
    ("Add or update comments in source code." ":bulb:" #x1F4A1)
    ("Writing code drunkenly." ":beers:" #x1F37B)
    ("Add or update text and literals." ":speech_balloon:" #x1F4AC)
    ("Perform database related changes." ":card_file_box:" #x1F5C3)
    ("Add or update logs." ":loud_sound:" #x1F50A)
    ("Remove logs." ":mute:" #x1F507)
    ("Add or update contributor(s)." ":busts_in_silhouette:" #x1F465)
    ("Improve user experience / usability." ":children_crossing:" #x1F6B8)
    ("Make architectural changes." ":building_construction:" #x1F3D7)
    ("Work on responsive design." ":iphone:" #x1F4F1)
    ("Mock things." ":clown_face:" #x1F921)
    ("Add or update an easter egg." ":egg:" #x1F95A)
    ("Add or update a .gitignore file." ":see_no_evil:" #x1F648)
    ("Add or update snapshots." ":camera_flash:" #x1F4F8)
    ("Experiment new things." ":alembic:" #x2697)
    ("Improve SEO." ":mag:" #x1F50D)
    ("Add or update types (Flow, TypeScript)." ":label:" #x1F3F7)
    ("Add or update seed files." ":seedling:" #x1F331)
    ("Add, update, or remove feature flags." ":triangular_flag_on_post:" #x1F6A9)
    ("Catching errors." ":goal_net:" #x1F945)
    ("Add or update animations and transitions." ":dizzy:" #x1F4AB)
    ("Deprecating code that needs to be cleaned up." ":wastebasket:" #x1F5D1)))

(defvar gitmoji--insert-utf8-emoji t
  "When nil, inserts a github-style emoji.
Example: :zap: instead of \u26a1.
Default: t.")

(defvar gitmoji--display-utf8-emoji t
  "When nil, does not use utf8 in the emoji list.
Default: t.")

(defun gitmoji-insert--candidates ()
  "Return a list of gitmojis to choose from."
  (mapcar (lambda (g)
            (let ((description (car g))
                  (shortcode (cadr g))
                  (utf8 (caddr g)))
              (cons
               (concat
                (if gitmoji--display-utf8-emoji (string utf8) shortcode)
                " \u2014 "
                description)
               g)))
          gitmojis-list))

(defun gitmoji-insert--action (g)
  "Insert a gitmoji, G, into the current buffer."
  (let ((utf8 (cadddr g))
        (shortcode (caddr g)))
    (if gitmoji--insert-utf8-emoji
        (insert-char utf8)
      (insert shortcode)))
  (insert " "))

(defun gitmoji-insert ()
  "Choose a gitmoji and insert it in the current buffer."
  (interactive)
  (let ((candidates (gitmoji-insert--candidates)))
    (ivy-read
     "Choose a gitmoji: "
     candidates
     :action #'gitmoji-insert--action)))

;;;###autoload
(define-minor-mode gitmoji-commit-mode
  "Toggle gitmoji-commit mode."
  :global t
  :init-value nil
  :lighter " gitmoji"
  (if gitmoji-commit-mode
      (add-hook 'git-commit-setup-hook 'gitmoji-insert)
    (remove-hook 'git-commit-setup-hook 'gitmoji-insert)))

(provide 'gitmoji)
;;; gitmoji.el ends here
