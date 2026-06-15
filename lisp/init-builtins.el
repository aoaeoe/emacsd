;;; package --- init.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; os & coding settings
(when (and evims-os-win
     (boundp 'w32-get-true-file-attributes))
  (setq w32-get-true-file-attributes nil
  w32-pipe-read-delay 0
  w32-pipe-buffer-size (* 64 1024)))

;; Special configs for macOS
(when evims-os-mac
  (setq mac-command-modifier 'meta
  mac-option-modifier 'super
  ns-use-native-fullscreen t))

;; solve the Chinese paste issue
;; let Emacs auto-guess the selection coding according to the Windows/system settings
(prefer-coding-system 'utf-8)
;; (setq locale-coding-system 'utf-8)
(unless evims-os-win
  (set-selection-coding-system 'utf-8))

;; core package settings
(use-package package
  :init
  (setq package-quickstart t)
  (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")))

;; make use-package default behavior better
;; with `use-package-always-ensure' you won't need ":ensure t" all the time
;; with `use-package-always-defer' you won't need ":defer t" all the time
(setq use-package-enable-imenu-support t
      use-package-expand-minimally t)

;; Emacs builtin packages
(setq-default auto-window-vscroll nil
              default-directory "~"
              frame-title-format "%b"
              help-window-select t
              initial-major-mode 'fundamental-mode
              inhibit-startup-screen t ; disable the startup screen splash
              kill-whole-line t
              make-backup-files nil ; disable backup file
              read-process-output-max (* 4 1024 1024)
              require-final-newline t
              scroll-conservatively 1000
              show-trailing-whitespace t
              system-time-locale "C"
              auto-save--default t
              use-short-answers t)


(defun efs/display-startup-time ()
  "Statistic for the startup time."
  (message "Emacs loaded in %s with %d garbage collections."
	   (format "%.2f seconds" (float-time (time-subtract after-init-time before-init-time)))
	   gcs-done))
(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;;;###autoload
(defun treesit-install-language-grammar-all()
  "Install all treesit language grammar."

  (interactive)
  (dolist (lang '(bash c go gomod html javascript json markdown python rust typescript yaml))
    (treesit-install-language-grammar lang)))


(setq default-frame-alist
      '((ns-title-hidden . t)
        (ns-fullsize-content . t)))

;; isearch
(use-package isearch
  :config
  (setq-default isearch-allow-motion t
    isearch-lazy-count t))

;; auto revert
;; `global-auto-revert-mode' is provided by autorevert.el (builtin)
(use-package autorevert
  :hook (after-init . global-auto-revert-mode))

;; auto save to the visited file (provided by `files.el')
(use-package files
  :hook (after-init . auto-save-visited-mode))

;; Delete Behavior
;; `delete-selection-mode' is provided by delsel.el (builtin)
(use-package delsel
  :hook (after-init . delete-selection-mode))

;; visual-line-mode
(use-package simple
  :hook (prog-mode . visual-line-mode))

;; pixel-scroll-precise-mode
(use-package pixel-scroll
  :hook (after-init . pixel-scroll-precision-mode))

;; fido-mode
;; `fido-mode' is provided by icomplete.el
(use-package icomplete
  :hook (after-init . fido-vertical-mode)
  :config (setq completions-detailed t))

(use-package nerd-icons-completion
  :if (display-graphic-p)
  :config
  (nerd-icons-completion-mode))

;; Highlight Current Line
(use-package hl-line
  :when (display-graphic-p)
  :hook (prog-mode . hl-line-mode))

;; ibuffer
(defalias 'list-buffers 'ibuffer)

;; Org Mode
(use-package org
  :hook (org-mode . org-num-mode)
  :config
  (setq org-hide-leading-stars t
  org-hide-emphasis-markers t
  org-startup-indented t))

;; Highlight Org Code
(setq org-src-fontify-natively t
      org-src-tab-acts-natively t)

;; Org Lang
(with-eval-after-load 'org
  (add-to-list 'org-src-lang-modes '("rust" . rust-ts))
  (add-to-list 'org-src-lang-modes '("go" . go-ts)))

;; Pulse the cursor line
(dolist (cmd '(recenter-top-bottom other-window))
  (advice-add cmd :after (lambda (&rest _) (pulse-momentary-highlight-one-line))))

;; Show Paren Mode
(use-package paren
  :config
  (setq show-paren-when-point-in-periphery t
  show-paren-when-point-inside-paren t
  show-paren-style 'mixed))

;; Recentf
(use-package recentf
  :hook (after-init . recentf-mode)
  ;; recentf-open since v29.1, recentf-open-files since v22
  :bind (("C-c r" . #'recentf-open)))

;; windmove.el, use  <SHIFT - arrow key> to switch buffers
(use-package windmove
  :config (windmove-default-keybindings))

;; Settings for which-key - suggest next key,Built in package now
(use-package whick-key
  :hook (after-init . which-key-mode))

;; programming language hooks
(add-hook 'prog-mode-hook (lambda () (setq-local column-number-mode t)))
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook 'electric-pair-mode)
(add-hook 'prog-mode-hook 'hs-minor-mode)
(add-hook 'prog-mode-hook 'prettify-symbols-mode)
(add-hook 'prog-mode-hook 'which-function-mode)

;; Flymake
(use-package flymake
  :hook (prog-mode . flymake-mode)
  :bind (("M-n" . #'flymake-goto-next-error)
         ("M-p" . #'flymake-goto-prev-error)))

;; Language Server (eglot - builtin since v29)
(use-package eglot
  :bind ("C-c e f" . eglot-format)
  :init
  (advice-add 'eglot-code-action-organize-imports :before #'eglot-format-buffer)
  (add-hook 'eglot-managed-mode-hook (lambda () (add-hook 'before-save-hook #'eglot-format-buffer)))
  (add-hook 'prog-mode-hook
      (lambda () (unless (member major-mode '(emacs-lisp-mode))
       (eglot-ensure)))))

(use-package treesit
  :when (and (fboundp 'treesit-available-p) (treesit-available-p))
  :mode (("\\(?:Dockerfile\\(?:\\..*\\)?\\|\\.[Dd]ockerfile\\)\\'" . dockerfile-ts-mode)
         ("\\.go\\'" . go-ts-mode)
         ("/go\\.mod\\'" . go-mod-ts-mode)
         ("\\.rs\\'" . rust-ts-mode)
         ("\\.ts\\'" . typescript-ts-mode)
         ("\\.y[a]?ml\\'" . yaml-ts-mode))
  :config (setq treesit-font-lock-level 4)
  ;; go-ts-mode indent 4 space
  (add-hook 'go-ts-mode-hook
            (lambda ()
              (setq go-ts-mode-indent-offset 4) ; indent width 4
              (setq tab-width 4)                ; tab width 4
              (setq indent-tabs-mode nil)))     ; indent not with tab
  :init
  (setq major-mode-remap-alist
  '((sh-mode         . bash-ts-mode)
    (c-mode          . c-ts-mode)
    (c++-mode        . c++-ts-mode)
    (c-or-c++-mode   . c-or-c++-ts-mode)
    (css-mode        . css-ts-mode)
    (js-mode         . js-ts-mode)
    (js-json-mode    . json-ts-mode)
    (makefile-mode   . cmake-ts-mode)
    (python-mode     . python-ts-mode)
    (ruby-mode       . ruby-ts-mode)
    (conf-toml-mode  . toml-ts-mode)))
  (setq treesit-language-source-alist
  '((bash       . ("https://github.com/tree-sitter/tree-sitter-bash"))
    (c          . ("https://github.com/tree-sitter/tree-sitter-c"))
    (cpp        . ("https://github.com/tree-sitter/tree-sitter-cpp"))
    (css        . ("https://github.com/tree-sitter/tree-sitter-css"))
    (cmake      . ("https://github.com/uyha/tree-sitter-cmake"))
    (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
    (elisp      . ("https://github.com/Wilfred/tree-sitter-elisp"))
    (go         . ("https://github.com/tree-sitter/tree-sitter-go"))
    (gomod      . ("https://github.com/camdencheek/tree-sitter-go-mod.git"))
    (html       . ("https://github.com/tree-sitter/tree-sitter-html"))
    (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
    (json       . ("https://github.com/tree-sitter/tree-sitter-json"))
    (lua        . ("https://github.com/Azganoth/tree-sitter-lua"))
    (make       . ("https://github.com/alemuller/tree-sitter-make"))
    (markdown   . ("https://github.com/MDeiml/tree-sitter-markdown" nil "tree-sitter-markdown/src"))
    (org        . ("https://github.com/milisims/tree-sitter-org"))
    (python     . ("https://github.com/tree-sitter/tree-sitter-python"))
    (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
    (tsx        . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
    (ruby       . ("https://github.com/tree-sitter/tree-sitter-ruby"))
    (rust       . ("https://github.com/tree-sitter/tree-sitter-rust"))
    (sql        . ("https://github.com/m-novikov/tree-sitter-sql"))
    (vue        . ("https://github.com/merico-dev/tree-sitter-vue"))
    (yaml       . ("https://github.com/ikatyang/tree-sitter-yaml"))
    (toml       . ("https://github.com/tree-sitter/tree-sitter-toml"))
    (zig        . ("https://github.com/GrayJack/tree-sitter-zig")))))


(provide 'init-builtins)

;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:

;;; init-builtins.el ends here
