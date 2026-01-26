;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-

;; (remove-hook! 'org-mode-hook #'org-superstar-mode)

(after! org
  (add-to-list 'org-agenda-files "~/work.org")
  ;; remove [tab] in org-mode
  ;; https://github.com/joaotavora/yasnippet/commit/25f5d8808af23fb3b3dd6a7aacb06e17006ffca6
  (define-key org-mode-map
              [tab] nil)
  (setq org-hide-leading-stars nil
        ;; org-fontify-quote-and-verse-blocks nil
        ;; org-fontify-whole-heading-line t
        org-startup-indented nil
        org-tags-column -77
        org-capture-templates
        '(("t" "Personal todo" entry
           (file +org-capture-todo-file)
           "* TODO %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)
          ("n" "New Customer Case" entry
           (file+headline "~/work.org.gpg" "Case Work log")
           "* [[https://command-center.support.aws.a2z.com/case-console#/cases/%^{Case_ID}][%\\1]] %^{Subject} \n%?\n"
           :clock-in t
           :clock-keep t)
          ("e" "New Ops Ticket" entry
           (file+headline "~/work.org.gpg" "Case Work log")
           "* [[https://t.corp.amazon.com/%^{Ticket_ID}][%\\1]] %^{Subject} %^g\n%?\n"
           :clock-in t
           :clock-keep t)
          ("c" "Manually Cc Case" entry
           (file+headline "~/work.org.gpg" "Cc Case")
           "* [[https://command-center.support.aws.a2z.com/case-console#/cases/%^{Case_ID}][%\\1]] %?")
          ("l" "Case WorkLog" entry
           (clock)
           "* WL:\n%U:\n- [ ] %?\n\n" :empty-lines 1)

          ;; Will use {project-root}/{todo,notes,changelog}.org, unless a
          ;; {todo,notes,changelog}.org file is found in a parent directory.
          ;; Uses the basename from `+org-capture-todo-file',
          ;; `+org-capture-changelog-file' and `+org-capture-notes-file'.
          ("p" "Templates for projects")
          ("pt" "Project-local todo" entry  ; {project-root}/todo.org
           (file+headline +org-capture-project-todo-file "Inbox")
           "* TODO %?\n%i\n%a" :prepend t)
          ("pn" "Project-local notes" entry  ; {project-root}/notes.org
           (file+headline +org-capture-project-notes-file "Inbox")
           "* %U %?\n%i\n%a" :prepend t)
          ("pc" "Project-local changelog" entry  ; {project-root}/changelog.org
           (file+headline +org-capture-project-changelog-file "Unreleased")
           "* %U %?\n%i\n%a" :prepend t)

          ;; Will use {org-directory}/{+org-capture-projects-file} and store
          ;; these under {ProjectName}/{Tasks,Notes,Changelog} headings. They
          ;; support `:parents' to specify what headings to put them under, e.g.
          ;; :parents ("Projects")
          ("o" "Centralized templates for projects")
          ("ot" "Project todo" entry
           (function +org-capture-central-project-todo-file)
           "* TODO %?\n %i\n %a"
           :heading "Tasks"
           :prepend nil)
          ("on" "Project notes" entry
           (function +org-capture-central-project-notes-file)
           "* %U %?\n %i\n %a"
           :heading "Notes"
           :prepend t)
          ("oc" "Project changelog" entry
           (function +org-capture-central-project-changelog-file)
           "* %U %?\n %i\n %a"
           :heading "Changelog"
           :prepend t))
        )

  (set-ligatures! 'org-mode
    :quote "#+begin_example"
    :quote_end "#+end_example")

  (setq org-archive-location "finished_archive::")

  (setq org-latex-compiler "xelatex")

  ;; Disable english dict and yasnippet-capf in org-mode. They slow down corfu.
  (setq text-mode-ispell-word-completion nil)
  (remove-hook 'completion-at-point-functions #'ispell-completion-at-point t)
  ;; (remove-hook 'completion-at-point-functions #'yasnippet-capf t)

  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines)))

  (register-aws-md)
)

(defun register-aws-md ()
  (org-export-define-derived-backend 'aws-md 'md
    :menu-entry
    '(?i "Export to AWS internal note" org-aws-md-export-as-markdown)
    :translate-alist
    '((timestamp . org-aws-md-timestamp))
  ))

(defun org-aws-md-export-as-markdown (a s v b)
  "export work log to command center case internal note."
  (interactive)
  (org-export-to-buffer 'aws-md "*AWS internal note Export*"
    a s v b nil (lambda ()
                      ;; (markdown-mode)
                      (kill-ring-save (point-min) (point-max))
                      (message "Internal note copied.")
                      (markdown-view-mode)
                      )))

(defun org-aws-md-timestamp (timestamp _contents info)
  "Transcode a TIMESTAMP object from Org to AWS Case internal note
CONTENTS is nil.  INFO is a plist holding contextual
information."
  (let ((value (org-html-plain-text (org-timestamp-translate timestamp) info)))
    (format "%s" value
	    )))

(defun yuanl/yank-markdown-as-org ()
  "Yank Markdown text as Org.

This command will convert Markdown text in the top of the `kill-ring'
and convert it to Org using the pandoc utility."
  (interactive)
  (save-excursion
    (with-temp-buffer
      (yank)
      (shell-command-on-region
       (point-min) (point-max)
       "pandoc -f markdown -t org --wrap=preserve" t t)
      (kill-region (point-min) (point-max)))
    (yank)))
