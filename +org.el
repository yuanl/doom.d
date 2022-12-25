;;; $DOOMDIR/+org.el -*- lexical-binding: t; -*-

;; (remove-hook! 'org-mode-hook #'org-superstar-mode)

(after! org
  (add-to-list 'org-agenda-files "~/work.org")
  (setq org-hide-leading-stars nil
        ;; org-fontify-quote-and-verse-blocks nil
        ;; org-fontify-whole-heading-line nil
        org-startup-indented t
        org-tags-column -77
        org-capture-templates
        '(("t" "Personal todo" entry
           (file +org-capture-todo-file)
           "* TODO %?\n%i\n%a" :prepend t)
          ("j" "Journal" entry
           (file+olp+datetree +org-capture-journal-file)
           "* %U %?\n%i\n%a" :prepend t)
          ("n" "New Customer Case" entry
           (file+headline "~/work.org" "Case Work log")
           "* %^{Case_ID} %^{Subject} %^g\n%?\n" :empty-lines 1)
          ("c" "Manually Cc Case" entry
           (file+headline "~/work.org" "Cc Case")
           "* [[https://command-center.support.aws.a2z.com/case-console#/cases/%^{Case_ID}][%\\1]] %?")
          ("l" "Case WorkLog" plain
           (clock)
           "\nWL:\n%U:\n- [ ] %?\n\n" :empty-lines 1)

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


  (setq org-archive-location "finished_archive::")

  (setq org-latex-compiler "xelatex")

  (use-package! ox-extra
    :config
    (ox-extras-activate '(latex-header-blocks ignore-headlines)))

  (use-package! opencc
    :commands (opencc-region))

  (use-package! pangu-spacing
    :config
    (require 'pangu-spacing)
    (setq pangu-spacing-real-insert-separtor t)
    ;; :hook (org-mode global-pangu-spacing-mode)
    )

)
