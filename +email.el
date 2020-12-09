;;; +mail.el -*- lexical-binding: t; -*-

(set-email-account! "Gmail"
                    '((user-mail-address . "yuanl.lee@gmail.com")
                      (mu4e-sent-folder . "/[Gmail].Sent Mail")
                      (mu4e-drafts-folder . "/Drafts")
                      (mu4e-trash-folder . "/[Gmail].Trash")
                      (mu4e-compose-signature . "-- \nLeonard"))
                    t)

(after! mu4e
  (setq mu4e-get-mail-command "proxychains4 mbsync -a"))
