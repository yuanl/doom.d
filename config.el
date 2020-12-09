;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yuanl"
      user-mail-address "yuanl.lee@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka Pragmata Slab" :size 14)
      doom-variable-pitch-font (font-spec :family "Iosevka Pragmata Slab" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dracula)
(setq doom-theme 'default)

;; Use a image as doom-dashboard.
(when (featurep! :ui doom-dashboard)
  (setq fancy-splash-image (expand-file-name "splash.png" doom-private-dir)))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(load! "+org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(when IS-MAC
  (setq mac-command-modifier 'meta
        mac-right-command-modifier 'super
        mac-option-modifier 'super
        mac-mouse-wheel-smooth-scroll t
        ))


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(use-package! sis
  :config
  (sis-ism-lazyman-config
   "com.apple.keylayout.ABC"
   "com.apple.inputmethod.SCIM.Shuangpin"
   )
  ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  (setq sis-other-cursor-color "grey")
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  ;; (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  ;; (sis-global-inline-mode t)
  )

(use-package! valign
  :hook (org-mode . valign-mode))

;; (use-package! ox-latex-chinese
;;   :after org
;;   :config (oxlc/toggle-ox-latex-chinese t))

(global-unset-key (kbd "C-SPC"))

(map! "s-o" (lookup-key (current-global-map) (kbd "C-x o"))  ;; Alias "C-x o" to "super-o"
      "C-." #'set-mark-command       ;; C-SPC reserved for system input
      ;; treemacs binding
      (:when (featurep! :ui treemacs)
       "s-t" #'treemacs
       "M-0" #'treemacs-select-window)
      ;;; smartparens
      (:after smartparens
        :map smartparens-mode-map
        "C-)" #'sp-forward-slurp-sexp
        "C-M-)" #'sp-forward-barf-sexp
        "C-("  #'sp-backward-slurp-sexp
        "C-M-("  #'sp-backward-barf-sexp)
      (:when (featurep! :term eshell)
       "s-e" #'+eshell/toggle)
      (:when (featurep! :term vterm)
       "s-e" #'+vterm/toggle)
      (:when (featurep! :checkers spell)
       "C-M-<tab>" #'company-ispell))

;;; show avator in magit
(after! magit
  (setq magit-revision-show-gravatars '("^Author:     " . "^Commit:     "))
  )

(defun dired-rename-sdcard ()
  "Rename SD card directory"
  (file-attribute-status-change-time (file-attributes "~/src")))
