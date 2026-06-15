;;; early-init.el --- the entry of emacs config -*- lexical-binding: t -*-
;;; Emacs 31 introudces early-init.el, which runs before init.el
;;; Commentary:
;; Runs before package and UI initializetion happens.
;;; Code:

(setq package-enable-at-startup nil)
(setq use-package-compute-statistics t)

(unless (>= emacs-major-version 30)
  (error "ONLY EMACS v30+ IS SUPPORTED!"))

;; For speed up the startup, please do NOT forget reset it to default
;; after Emacs after-init-hook, or it may cause freezes.
(setq gc-cons-threshold (* 512 1024 1024))
(setq gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (setq gc-cons-threshold (* 64 1024 1024)
        gc-cons-percentage 0.2)))

;; title bar color
(add-to-list 'default-frame-alist '(ns-appearance . dark))
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Clean GUI
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; window width height
(setq default-frame-alist
      (append '((width . 121) (height . 41))
              default-frame-alist))


(provide 'early-init)


;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:
;;; early-init.el ends here
