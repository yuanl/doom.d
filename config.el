;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yuanliang"
      user-mail-address "yuanl.lee@gmail.com")

;; When I bring up Doom's scratch buffer with SPC x, it's often to play with
;; elisp or note something down (that isn't worth an entry in my org files). I
;; can do both in `lisp-interaction-mode'.
;; (setq doom-scratch-initial-major-mode 'lisp-interaction-mode)

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
(setq doom-font (font-spec :family "Iosevka SS05" :size 16)
      doom-variable-pitch-font (font-spec :family "Iosevka SS05"))

(setq shell-file-name (executable-find "bash")
      vterm-shell (executable-find "fish"))

;; This trick has huge performance gain on long-line
;; https://emacs-china.org/t/topic/25811
(setq-default bidi-display-reordering nil)
(setq bidi-inhibit-bpa t
      long-line-threshold 1000
      large-hscroll-threshold 1000
      syntax-wholeline-max 1000)

(set-language-environment "UTF-8")
(load! "+cnfont")

(use-package! modus-themes
  :config
  (mapc #'disable-theme custom-enabled-themes)
  (load-theme 'modus-operandi :no-confirm)
  )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'modus-operandi)
;; (setq doom-theme nil)

;; Use a image as doom-dashboard.
(when (modulep! :ui doom-dashboard)
  (setq fancy-splash-image (expand-file-name "splash.png" doom-private-dir)))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(load! "+org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq word-wrap-by-category t)
(setq display-line-numbers-type t)
(remove-hook! '(text-mode-hook) #'display-line-numbers-mode)
;; (remove-hook! (prog-mode conf-mode) #'highlight-numbers-mode)
(setq +emacs-lisp-enable-extra-fontification nil)

;; (add-to-list 'initial-frame-alist '(fullscreen . maximized))

(when IS-MAC
  (setq mac-option-modifier 'meta
        mac-right-option-modifier 'meta
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
      "C-+" #'er/expand-region       ;; Easier for split keyboard
      ;; treemacs binding
      (:when (modulep! :ui treemacs)
        "s-j" #'treemacs
        "M-0" #'treemacs-select-window)
      ;; eww browser
      ;; "s-b" #'eww
      ;;; smartparens
      (:after smartparens
       :map smartparens-mode-map
       "C-)" #'sp-forward-slurp-sexp
       "C-M-)" #'sp-forward-barf-sexp
       "C-("  #'sp-backward-slurp-sexp
       "C-M-("  #'sp-backward-barf-sexp)
      (:when (modulep! :term eshell)
        "s-t" #'+eshell/toggle)
      (:when (modulep! :term vterm)
        "s-t" #'+vterm/toggle)
      (:when (modulep! :checkers spell)
        "C-M-<tab>" #'company-ispell)
      (:when (modulep! :app rss)
        "C-x w" #'elfeed)
      (:when (modulep! :lang org)
        "s--" #'org-insert-todo-heading)
      (:when (modulep! :tools lsp +eglot)
        "s-e" #'eglot)
      (:when (modulep! :tools magit)
        "M-s-G" #'magit)
      )

(when (modulep! :email mu4e)
  (load! "+email"))

(use-package! rime                      ;; 中文输入法的部分
  :init
  ;; (defun rime--disable-candidate-num (_)
  ;;   "Disable numbering the candidate."
  ;;   "")
  :custom
  (rime-librime-root (expand-file-name "librime/dist/" doom-emacs-dir))
  (rime-emacs-module-header-root (expand-file-name "../include" data-directory))
  (rime-user-data-dir "~/Library/Rime/")
  (default-input-method "rime")
  ;; (rime-show-candidate 'popup)
  ;; (rime-posframe-properties '(:internal-border-width 6))
  (rime-disable-predicates '(rime-predicate-after-alphabet-char-p
                             rime-predicate-space-after-cc-p)
                             rime-predicate-current-uppercase-letter-p
                             ;; rime-predicate-prog-in-code-p
                             rime-predicate-org-in-src-block-p
                             rime-predicate-ace-window-p
                           )
  ;; (rime-show-preedit 'inline)
  ;; (rime-candidate-num-format-function #'rime--disable-candidate-num)
)

;; new pixel scroll feature in emacs29
(pixel-scroll-precision-mode t)

(after! ace-window
  (custom-set-faces!
  '(aw-leading-char-face
    :foreground "white" :background "red"
    :weight bold :height 2.5 :box (:line-width 10 :color "red"))))

;; (use-package! langtool
;;   :init (setq langtool-default-language "en-GB"))

(use-package! whole-line-or-region
  :init
  (add-hook! 'after-init-hook 'whole-line-or-region-global-mode t))

(after! eshell
  :config
  (add-hook! 'eshell-mode-hook
    (defun +eshell-no-auto-complete-h ()
      "Disable auto completion at eshell."
      (setq-local company-idle-delay nil))))

(use-package! vterm
  :init
  (setq vterm-always-compile-module t)
  :config
  (add-to-list 'vterm-tramp-shells '("ssh" "/bin/bash")))

(use-package! opencc
  :commands (opencc-replace-at-point)
  :config
  (add-to-list 'opencc-configuration-files "aws")
  )

(use-package! shell-maker)
(use-package! chatgpt-shell
  :config
  (setq chatgpt-shell-openai-key
        (auth-source-pick-first-password :host "api.openai.com"))
  (add-to-list 'chatgpt-shell-system-prompts
               '("EN_ZH Translate" . "You are a helpful English to Chinese assistant.")))

(setq gcmh-high-cons-threshold (* 256 1024 1024))

(use-package! grab-mac-link
  :config
  (setq grab-mac-link-dwim-favourite-app 'firefox)
  :bind ("s-b" . grab-mac-link-dwim))

(use-package! epa
  :config
  (setq epg-pinentry-mode 'ask)
  )

(after! eglot
  :config (eglot-booster-mode))

(use-package! eglot-booster
  :init
  (setq eglot-booster-io-only t))

;; (use-package! company
;;   :custom
;;   (company-dabbrev-char-regexp "[A-Za-z-_]"))   ;; Do not try to complete on non-alphabe char.

(use-package! ansi-color
  :config
  (defun display-ansi-colors ()
    (interactive)
    (ansi-color-apply-on-region (point-min) (point-max)))
  )

(use-package! rjsx-mode
  :config
  (set-lookup-handlers! '(js-mode js-ts-mode js2-mode rjsx-mode)
    :definition #'lsp-bridge-find-def
    :references #'lsp-bridge-find-references
    :documentation #'lsp-bridge-show-documentation)
  )

(use-package! js2-refactor-mode
  :bind
  (("M-p" . js2r-move-line-up)
   ("M-n" . js2r-move-line-down))
  )

(use-package! consult-yasnippet
  :bind
  (("C-M-y" . consult-yasnippet)))

(use-package! pulsar
  :config
  (add-to-list 'pulsar-pulse-functions #'ace-window)
  (pulsar-global-mode 1))

(use-package! ultra-scroll
  :init
  (setq scroll-conservatively 101
        scroll-margin 0)
  :config
  (ultra-scroll-mode 1))

;; (use-package! org-modern
;;   :init
;;   (modify-all-frames-parameters
;;    '((right-divider-width . 40)
;;      (internal-border-width . 40)))
;;   (dolist (face '(window-divider
;;                   window-divider-first-pixel
;;                   window-divider-last-pixel))
;;     (face-spec-reset-face face)
;;     (set-face-foreground face (face-attribute 'default :background)))
;;   (set-face-background 'fringe (face-attribute 'default :background))
;;   :config
;;   ;; org-modern
;;   (setq
;;    ;; Edit settings
;;    org-auto-align-tags nil
;;    org-tags-column 0
;;    org-catch-invisible-edits 'show-and-error
;;    org-special-ctrl-a/e t
;;    org-insert-heading-respect-content t

;;    ;; Org styling, hide markup etc.
;;    org-hide-emphasis-markers t
;;    org-pretty-entities t
;;    org-agenda-tags-column 0))

(use-package! emt
  :hook (after-init . emt-mode))

(use-package! systemd)
