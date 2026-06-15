;;; init.el --- the entry of emacs config -*- lexical-binding: t -*-
;; Author: Evims
;;; Commentary:
;;; Code:


;;(defvar rime-emacs-module-header-root nil "Rime模块头文件路径.")
;;(defvar rime-librime-root nil "Librime库路径.")
(defvar url-proxy-services nil "代理.")
;; set proxy
(setq url-proxy-services
      '(("http" . "127.0.0.1:7897")
        ("https" . "127.0.0.1:7897")))
(setenv "http_proxy" "http://127.0.0.1:7897")
(setenv "https_proxy" "http://127.0.0.1:7897")

;; set rime env
;; (setq rime-emacs-module-header-root "/Applications/Emacs.app/Contents/Resources/include")
;; (setq rime-librime-root "/opt/homebrew/opt/librime")

;; variables definition
(defvar evims-os-win (memq system-type '(ms-dos windows-nt cygwin)))
(defvar evims-os-mac (eq system-type 'darwin))

;; font settings
;; (defvar font-name "Consolas Nerd Font")
;; (when (find-font (font-spec :family font-name))
;;   (set-face-attribute 'default nil :family font-name))

(set-frame-parameter nil 'alpha 0.95)  ;; set 透明度

(require 'package)
(package-initialize)

;; (require 'benchmark-init)

;; pre-settings
(add-to-list 'load-path (concat user-emacs-directory "lisp"))

;; builtin settings
(require 'init-builtins)

;; third-part packages
(require 'init-third-packages)


;; custom file settings
(setq custom-file (locate-user-emacs-file "custom.el"))
(when (file-exists-p custom-file)
  (load custom-file))

(provide 'init)

;;; init.el ends here
;; (custom-set-variables
;;  '(package-vc-selected-packages '((appine :url "https://github.com/chaoswork/appine"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:
