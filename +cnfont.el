;;; $DOOMDIR/+cnfont.el -*- lexical-binding: t; -*-

(defun setup-chinese-fonts ()
  "Use another font for Chinese charater"
  (when (display-graphic-p)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset (font-spec :family (cond (IS-MAC "LXGW WenKai Mono GB") ;;中文效果，言字
                                                       (IS-LINUX "Source Han Serif SC"))
                                         ;; :weight 'semi-bold
                                         )))))

(add-hook! doom-first-buffer #'setup-chinese-fonts)
