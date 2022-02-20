;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "YuanLiang"
      user-mail-address "yuanl.lee@gmail.com")

;; When I bring up Doom's scratch buffer with SPC x, it's often to play with
;; elisp or note something down (that isn't worth an entry in my org files). I
;; can do both in `lisp-interaction-mode'.
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

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
(setq doom-font (font-spec :family "Iosevka Slab" :size 14)
      doom-variable-pitch-font (font-spec :family "iosevka Slab"))

(load! "+cnfont")

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dracula)
;;(setq doom-theme 'doom-solarized-light)
(setq doom-theme 'modus-operandi)

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

(global-unset-key (kbd "C-SPC"))

(map! "s-o" (lookup-key (current-global-map) (kbd "C-x o"))  ;; Alias "C-x o" to "super-o"
      "C-." #'set-mark-command       ;; C-SPC reserved for system input
      ;; treemacs binding
      (:when (featurep! :ui treemacs)
       "s-j" #'treemacs
       "M-0" #'treemacs-select-window)
      ;; eww browser
      "s-b" #'eww
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
       "s-t" #'+vterm/toggle)
      (:when (featurep! :checkers spell)
       "C-M-<tab>" #'company-ispell)
      (:when (featurep! :app rss)
       "C-x w" #'elfeed))

(defun dired-rename-sdcard ()
  "Rename SD card directory"
  (file-attribute-status-change-time (file-attributes "~/src")))

(when (featurep! :ui doom-dashboard)
  (add-to-list '+doom-dashboard-menu-sections
               '("Open magit project"
                 :when (featurep! :tools magit)
                 :icon (all-the-icons-octicon "mark-github" :face 'doom-dashboard-menu-title)
                 :action magit-status))
  (add-to-list '+doom-dashboard-menu-sections
               '("Search Org"
                 :when (featurep! :lang org)
                 :icon (all-the-icons-octicon "search" :face 'doom-dashboard-menu-title)
                 :action +default/org-notes-search)))

(when (featurep! :email mu4e)
  (load! "+email"))

;; (use-package! rime                      ;; 中文输入法的部分
;;   :init
;;   (defun rime--disable-candidate-num (_)
;;     "Disable numbering the candidate."
;;     "")
;;   :custom
;;   (rime-librime-root "/opt/local/")
;;   (rime-emacs-module-header-root (expand-file-name "../include" data-directory))
;;   (rime-user-data-dir "~/Library/Rime/")
;;   (default-input-method "rime")
;;   (rime-show-candidate 'posframe)
;;   (rime-posframe-properties '(:internal-border-width 6))
;;   (rime-disable-predicates '(rime-predicate-after-alphabet-char-p
;;                              rime-predicate-prog-in-code-p
;;                              rime-predicate-ace-window-p
;;                              rime-predicate-space-after-cc-p))
;;   (rime-show-preedit 'inline)
;;   (rime-candidate-num-format-function #'rime--disable-candidate-num))

;; eliminated wrong argument issue in emacs29
(general-auto-unbind-keys :off)
(remove-hook 'doom-after-init-modules-hook #'general-auto-unbind-keys)

;; new pixel scroll feature in emacs29
(pixel-scroll-precision-mode t)

(after! ace-window
  (custom-set-faces!
  '(aw-leading-char-face
    :foreground "white" :background "red"
    :weight bold :height 2.5 :box (:line-width 10 :color "red"))))

(use-package! langtool
  :init (setq langtool-default-language "en-GB"))

(use-package! whole-line-or-region
  :init
  (add-hook! 'after-init-hook 'whole-line-or-region-global-mode t))

(after! eshell
  :config
  (add-hook! 'eshell-mode-hook
    (defun +eshell-no-auto-complete-h ()
      "Disable auto completion at eshell."
      (setq-local company-idle-delay nil))))
