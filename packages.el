;;; packages.el --- gonw layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author:  <liuwei@LIUWEI-PC>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `gonw-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `gonw/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `gonw/pre-init-PACKAGE' and/or
;;   `gonw/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:

(defconst gonw-packages
  '(
     company
     cc-mode
     wttrin
     zoom-frm
     ycmd
     magit
     magit-gerrit
     moe-theme
     (visual-basic-mode :location (recipe
                                    :fetcher github
                                    :repo "emacsmirror/visual-basic-mode"
                                    ;; :files ("visual-basic-mode.el")
                                    ))
     (sr-speedbar :location (recipe
                              :fetcher github
                              :repo "emacsmirror/sr-speedbar"
                              ))
     (unicad :location (recipe
                        :fetcher github
                        :repo "7696122/unicad"
                        :files ("lisp/unicad.el")))
     ;; vbasense
     chinese-fonts-setup
     counsel
     (counsel-sift :location (recipe
                               :fetcher github
                               :repo "appleshan/emacs-counsel-sift"
                               ;; :files ("visual-basic-mode.el")
                               ))
     e2wm
     window-layout
     )
  "The list of Lisp packages required by the gonw layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

;; 天气
(defun gonw/init-wttrin()
  (use-package wttrin
    :ensure t
    :commands (wttrin)
    :init
    ;; (setq wttrin-default-cities '("Wuhan" "Bristol"))))
    (setq wttrin-default-cities '("Wuhan"))))

(defun gonw/init-chinese-fonts-setup()
  (use-package chinese-fonts-setup
    :init
    (setq cfs-profiles '("program" "org-mode" "read-book"))
    ;; (setq cfs-keep-frame-size nil)
    ))

;; vb-mode
(defun gonw/init-visual-basic-mode ()
  (use-package visual-basic-mode
    :if (configuration-layer/package-usedp 'company)
    :mode ("\\.\\(frm\\|bas\\|vbs\\|vb\\|cls\\)$" . visual-basic-mode)
    )
  )

(when (configuration-layer/package-usedp 'company)
  (defun gonw/post-init-visual-basic-mode ()
    (spacemacs|add-company-hook visual-basic-mode)
    ))

(defun gonw/post-init-sr-speedbar ()
  (defun spacemacs/sr-speedbar-show-or-hide ()
    (interactive)
    (cond ((sr-speedbar-exist-p) (kill-buffer speedbar-buffer))
      (t (sr-speedbar-open) (linum-mode -1) (speedbar-refresh)))))

(defun gonw/init-sr-speedbar ()
  (use-package sr-speedbar
    :init
    (setq sr-speedbar-width 30)
    (setq sr-speedbar-right-side nil)
    :config
    (evil-leader/set-key
      "ft" 'spacemacs/sr-speedbar-show-or-hide)
    ;; (spacemacs|evilify-map speedbar-mode-map)
    ))

;; 自动识别文件编码
(defun unicad/init-unicad ()
 (use-package unicad
   ))


(defun gonw/init-vbasense ()
  (use-package vbasense
    )
  (vbasense-config-default))


;; 鼠标滚轮缩放字体
(defun gonw/post-init-zoom-frm ()
  ;; (global-set-key (kbd "<C-wheel-up>") (lambda () (interactive) (bhj-step-frame-font-size 1)))
  ;; (global-set-key (kbd "<C-wheel-down>") (lambda () (interactive) (bhj-step-frame-font-size -1)))

  ; or (when window-system
  (when (display-graphic-p)
    (if(eq system-type 'windows-nt)
      (progn
        (global-set-key (kbd "<C-wheel-up>") (lambda () (interactive) (cfs-increase-fontsize)))
        (global-set-key (kbd "<C-wheel-down>") (lambda () (interactive) (cfs-decrease-fontsize)))))
    (if (eq system-type 'gnu/linux)
      (progn
        (global-set-key (kbd "<C-mouse-4>") (lambda () (interactive) (cfs-increase-fontsize)))
        (global-set-key (kbd "<C-mouse-5>") (lambda () (interactive) (cfs-decrease-fontsize))))))
  )


(defun gonw/post-init-magit ()
  ;; (add-hook 'git-commit-mode-hook
  ;;   '(lambda () (auto-fill-mode 0))
  ;;   ;; append rather than prepend to git-commit-mode-hook, since the
  ;;   ;; thing that turns auto-fill-mode on in the first place is itself
  ;;   ;; another hook on git-commit-mode.
  ;;   t)
  )

(defun gonw/init-magit-gerrit ()
  (use-package magit-gerrit
    :init
    ;; if remote url is not using the default gerrit port and
    ;; ssh scheme, need to manually set this variable
    ;; (setq-default magit-gerrit-ssh-creds "myid@gerrithost.org")
    (setq-default magit-gerrit-ssh-creds "your@mail.com")

    ;; if necessary, use an alternative remote instead of 'origin'
    (setq-default magit-gerrit-remote "gerrit")
    )
  )

(defun gonw/init-company ()
  (setq company-dabbrev-downcase nil)
  )

(defun gonw/init-moe-theme ()
  )

(defun gonw/pre-init-ycmd()
  (setq ycmd-server-command '("c:\\python27\\python.exe" "-u" "d:\\bin\\ycmd\\ycmd\\"))
  )

;; astyle处理
(defun gonw/post-init-cc-mode ()
  (spacemacs/set-leader-keys-for-major-mode 'c-mode "ab" 'astyle-buffer)
  (spacemacs/set-leader-keys-for-major-mode 'c++-mode "ab" 'astyle-buffer)
  (spacemacs/set-leader-keys-for-major-mode 'c-mode "ar" 'astyle-region)
  (spacemacs/set-leader-keys-for-major-mode 'c++-mode "ar" 'astyle-region)
  (add-to-list 'company-backends-c-mode-common 'company-semantic)
  (add-hook 'c-mode-hook
    (lambda ()
      (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
        (ggtags-mode 1))))
  )

;; 搜索工具
(defun gonw/init-counsel()
  (use-package counsel))

(defun gonw/init-counsel-sift ()
  (use-package counsel-sift
    :config
    (progn
      (spacemacs/set-leader-keys
        "osf" 'spacemacs/search-sift
        "osF" 'spacemacs/search-sift-region-or-symbol
        "osp" 'spacemacs/search-project-sift
        "osP" 'spacemacs/search-project-sift-region-or-symbol
        )
      )))

(defun gonw/init-e2wm()
  (use-package e2wm))

(defun gonw/init-window-layout()
  (use-package window-layout))

;;; packages.el ends here
