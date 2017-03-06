;;; funcs.el --- gonw Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: gonw
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Based on the Sarcasm/irony-mode compilation database code.

  ;;astyle
  (defvar astyle-command "F:\\path\\to\\astyle\\bin -n -c -j -K -k3 -Y -f -U -A1 -p -H -d --mode=c -s4 -S -Z")
  (defun astyle-region (start end)
    "Run astyle on region, formatting it in a pleasant way."
    (interactive "r")
    (save-excursion
      (shell-command-on-region start end astyle-command nil t (get-buffer-create "*Astyle Errors*") nil)
      )
    )
  ;; 保存文件时自动进行astyle
  ;; (defun astyle-buffer ()
  ;;   "Run astyle on whole buffer, formatting it in a pleasant way."
  ;;   (interactive)
  ;;   (save-excursion
  ;;     (astyle-region (point-min) (point-max))))
  (defun astyle-buffer ()
    "Run astyle on whole buffer, formatting it in a pleasant way."
    (interactive)
    (setq astyle-temp-point (point))
    (astyle-region (point-min) (point-max))
    (goto-char astyle-temp-point))

  ;; (add-hook 'c-mode-common-hook
  ;;   '(lambda ()
  ;;      ;; (define-key c-mode-map "\C-cr" 'astyle-region)
  ;;      (define-key c-mode-map "<leader>ar" 'astyle-region)
  ;;      (define-key c-mode-map "\C-cb" 'astyle-buffer)
  ;;      (define-key c++-mode-map "\C-cr" 'astyle-region)
  ;;      (define-key c++-mode-map "\C-cb" 'astyle-buffer)))
  ;; (add-hook 'before-save-hook
  ;;   '(lambda ()
  ;;      (if (file-exists-p (buffer-file-name))                 ; 已存在文件
  ;;        (if (member (file-name-extension (buffer-name))
  ;;              '("cpp" "h" "c"))
  ;;          (astyle-buffer))
  ;;        )))
