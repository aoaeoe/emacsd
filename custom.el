;;; customer.el --- the entry of emacs config -*- lexical-binding: t -*-
;;; Package --- init-theme.el -*- flymake-mode: nil; -*-
;;; Commentary:
;;; Code:

(custom-set-variables
 '(ignored-local-variable-values '((flymake-mode)))
 '(package-selected-packages
   '(all-the-icons-completion all-the-icons-dired centaur-tabs company
                              dirvish doom-modeline doom-themes
                              eldoc-box exec-path-from-shell
                              format-all ghostel htmlize iedit llama
                              markdown-mode move-dup
                              nerd-icons-completion protobuf-mode
                              quickrun restclient rime rimel sideline
                              spaceline-all-the-icons transient
                              treemacs-all-the-icons
                              treemacs-projectile vterm-toggle
                              which-key with-editor yasnippet)))

(custom-set-faces
 '(tab-bar ((t (:inherit mode-line :box nil))))
 '(tab-bar-tab ((t (:inherit mode-line :foreground "gainsboro" :box nil))))
 '(tab-bar-tab-inactive ((t (:inherit mode-line-inactive :foreground "DarkGray" :box nil)))))
