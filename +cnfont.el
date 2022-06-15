;;; $DOOMDIR/+cnfont.el -*- lexical-binding: t; -*-

(defun setup-chinese-fonts ()
  "Use another font for Chinese charater"
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset (font-spec :family (cond (IS-MAC "PingFang SC") ;;中文效果，言字
                                                       (IS-LINUX "Source Han Serif SC"))
                                         :weight 'medium))))

(add-hook! doom-first-buffer #'setup-chinese-fonts)
