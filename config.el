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
(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-variable-pitch-font (font-spec :family "Iosevka"))

(set-language-environment "UTF-8")
(load! "+cnfont")

(use-package! modus-themes
  :config
  (setq modus-themes-org-blocks 'gray-background
        modus-themes-headings ; this is an alist: read the manual or its doc string
        '((1 . (rainbow overline))
          (2 . (rainbow))
          (t . (semibold))))

  (setq modus-themes-common-palette-overrides
      '((border-mode-line-active unspecified)
        (border-mode-line-inactive unspecified)
        ;; (bg-mode-line-active bg-cyan-subtle)
        ;; (fg-mode-line-active cyan-faint)
        ))

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
(setq org-directory "~/")
(load! "+org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)
(setq word-wrap-by-category t)

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
       "s-e" #'lsp-bridge-toggle-sdcv-helper)


(when (modulep! :ui doom-dashboard)
  (add-to-list '+doom-dashboard-menu-sections
               '("Open magit project"
                 :when (modulep! :tools magit)
                 :icon (nerd-icons-octicon "nf-oct-git_branch" :face 'doom-dashboard-menu-title)
                 :action magit-status))
  ;; (add-to-list '+doom-dashboard-menu-sections
  ;;              '("Start Working"
  ;;                :when (file-exists-p! "~/work.org.gpg")
  ;;                :icon (nerd-icons-octicon "nf-oct-checkbox" :face 'doom-dashboard-menu-title)
  ;;                :action #'(find-file "~/work.org.gpg")))

  ;; (add-to-list '+doom-dashboard-menu-sections
  ;;              '("Search Org"
  ;;                :when (modulep! :lang org)
  ;;                :icon (all-the-icons-octicon "search" :face 'doom-dashboard-menu-title)
  ;;                :action +default/org-notes-search))
  )

(when (modulep! :email mu4e)
  (load! "+email"))

(use-package! rime                      ;; 中文输入法的部分
  :init
  ;; (defun rime--disable-candidate-num (_)
  ;;   "Disable numbering the candidate."
  ;;   "")
  :custom
  (rime-librime-root "/opt/local/")
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

;; (after! lsp-yamls
;;   :config
;;   (setq lsp-yaml-schemas '(:kubernetes "/*.yaml")))

(use-package! vterm
  :config
  (setq vterm-always-compile-module t))

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-python-command "python3.11"
        lsp-bridge-enable-search-words nil
        acm-enable-search-file-words nil
        acm-enable-doc nil
        acm-enable-tabnine nil
        acm-enable-path t
        acm-backend-yas-candidate-min-length 2
        lsp-bridge-python-command "python3.11")
  ;; (yas-global-mode 1)
  :init
  (global-lsp-bridge-mode)
  )

(use-package! opencc
  :commands (opencc-replace-at-point)
  :config
  (add-to-list 'opencc-configuration-files "aws")
  )

;; (use-package! pangu-spacing
;;   :config
;;   (setq pangu-spacing-real-insert-separtor t)
;;   ;; (pangu-spacing-mode 1)
;;   :hook (org-mode pangu-spacing-mode)
;;   )

(remove-hook! (prog-mode conf-mode) #'highlight-numbers-mode)
(setq +emacs-lisp-enable-extra-fontification nil)

;; (after! elisp-mode
;;   (remove-hook! 'emacs-lisp-mode-hook
;;     #'rainbow-delimiters-mode
;;     #'highlight-quoted-mode
;;     #'outline-minor-mode))

;; (use-package! mind-wave)
(use-package! shell-maker)
(use-package! chatgpt-shell
  :config
  (setq chatgpt-shell-openai-key
        (auth-source-pick-first-password :host "api.openai.com"))
  (add-to-list 'chatgpt-shell-system-prompts
               '("EN_ZH Translate" . "You are a helpful English to Chinese assistant.")))

;; (use-package! org-modern
;;   :hook (org-mode . org-modern-mode)
;;   :custom (line-spacing 0.1))

(setq gcmh-high-cons-threshold (* 256 1024 1024))

(use-package! grab-mac-link
  :config
  (setq grab-mac-link-dwim-favourite-app 'firefox)
  :bind ("s-b" . grab-mac-link-dwim))


(use-package! epa
  :config
  (setq epg-pinentry-mode 'ask)
  )
