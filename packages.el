;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;(package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/raxod502/straight.el#the-recipe-format
;(package! another-package
;  :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;(package! this-package
;  :recipe (:host github :repo "username/repo"
;           :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;(package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;(package! builtin-package :recipe (:nonrecursive t))
;(package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see raxod502/straight.el#279)
;(package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;(package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;(unpin! pinned-package)
;; ...or multiple packages
;(unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;(unpin! t)

(package! osx-trash :disable t)
;; (package! rime :pin "e5727c5218a4345adb9b960cf6f4202246aea70c")
(package! langtool)
(package! whole-line-or-region)

(package! ef-themes)

(package! orderless)
(package! postframe
  :recipe (:host github :repo "tumashu/posframe"))

(package! lsp-bridge
  :recipe (:host github
           :repo "manateelazycat/lsp-bridge"
           :files (:defaults "*.py" "core" "langserver" "acm" "multiserver" "resources")
           :build (:not compile)
           )
  :pin "378f5614408e49c0c3d5e85e20708fa50b1a0e62")

;; (package! deno-bridge
;;   :recipe (
;;            :host github
;;            :repo "manateelazycat/deno-bridge"
;;            :files (:defaults "*.py")))

;; (package! deno-bridge-jieba
;;   :recipe (:host github
;;            :repo "ginqi7/deno-bridge-jieba"
;;            :files (:defaults "*.ts")))

;; (package! websocket)

;; (package! org-modern)

(package! opencc)

(package! rime)

;; (package! shell-maker
;;   :recipe (:host github :repo "xenodium/chatgpt-shell" :files ("shell-maker.el")))

(package! chatgpt-shell
  :recipe (:host github :repo "xenodium/chatgpt-shell"
           :files(:defaults)))

(package! nginx-mode
  :recipe (:host github :repo "ajc/nginx-mode"))

(package! grab-mac-link)
