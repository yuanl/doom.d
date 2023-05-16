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
(setq doom-font (font-spec :family "Iosevka Slab" :size 16)
      doom-variable-pitch-font (font-spec :family "Bookerly"))

(set-language-environment "UTF-8")
(load! "+cnfont")

(use-package! modus-themes
  :init
  (setq modus-themes-mode-line '(accented borderless)
        modus-themes-paren-match '(bold intense)
        modus-themes-org-blocks 'gray-background
        modus-themes-headings ; this is an alist: read the manual or its doc string
        '((1 . (rainbow overline))
          (2 . (rainbow))
          (t . (semibold))))
  :config
  ;; (modus-themes-load-theme 'modus-operandi)
  ;; (modus-themes-load-operandi)
  (load-theme 'modus-operandi :no-confim)
  )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-dracula)
;;(setq doom-theme 'doom-solarized-light)
;; (setq doom-theme 'modus-operandi)

;; Use a image as doom-dashboard.
(when (modulep! :ui doom-dashboard)
  (setq fancy-splash-image (expand-file-name "splash.png" doom-private-dir)))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(load! "+org")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)
(setq word-wrap-by-category t)

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

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
      "s-b" #'eww
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
                 :icon (all-the-icons-octicon "mark-github" :face 'doom-dashboard-menu-title)
                 :action magit-status))
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
                             rime-predicate-current-uppercase-letter-p
                             rime-predicate-prog-in-code-p
                             rime-predicate-org-in-src-block-p
                             rime-predicate-ace-window-p
                             rime-predicate-space-after-cc-p))
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

(use-package! lsp-bridge
  :config
  (setq lsp-bridge-enable-search-words nil
        acm-enable-search-file-words nil
        acm-enable-doc nil)
  (yas-global-mode 1)
  (global-lsp-bridge-mode)
  )

;; (use-package! sis
;;   :config
;;   (setq sis-respect-evil-normal-escape nil)
;;   (sis-ism-lazyman-config
;;    "com.apple.keylayout.ABC"
;;    "im.rime.inputmethod.Squirrel.Rime")
;;   (sis-global-respect-mode t))

;; (use-package! deno-bridge-jieba
;;   :config
;;   ;; (deno-bridge-jieba-start)
;;   :bind (([remap forward-word] . deno-bridge-jieba-forward-word)
;;          ([remap backward-word] . deno-bridge-jieba-backward-word)
;;          ([remap kill-word]. deno-bridge-jieba-kill-word)
;;          ([remap backward-kill-word] . deno-bridge-jieba-backward-kill-word)
;;          ))

(use-package! opencc
  :commands (opencc-replace-at-point)
  :custom
  (opencc-configuration-files '("aws"
                                "s2t"
                                "t2s"
                                "s2tw"
                                "tw2s"
                                "s2hk"
                                "hk2s"
                                "s2twp"
                                "tw2sp")))

;; (use-package! pangu-spacing
;;   :config
;;   (setq pangu-spacing-real-insert-separtor t)
;;   ;; (pangu-spacing-mode 1)
;;   :hook (org-mode pangu-spacing-mode)
;;   )

(remove-hook! (prog-mode conf-mode) #'highlight-numbers-mode)
(setq +emacs-lisp-enable-extra-fontification nil)

(after! elisp-mode
  (remove-hook! 'emacs-lisp-mode-hook
    #'rainbow-delimiters-mode
    #'highlight-quoted-mode
    #'outline-minor-mode))

(use-package! mind-wave)

(use-package! org-modern
  :hook (org-mode . org-modern-mode))
