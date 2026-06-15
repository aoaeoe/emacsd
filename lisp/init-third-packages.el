;;; package --- init-third-packages.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;; Settings for company, auto-complete only for coding.
(use-package company
  :ensure t
  :hook (prog-mode . company-mode))

;; Set PATH and `exec-path'
;; $ fish -lc 'printf "%s\n" "$PATH"' > ~/.emacs.d/.path
(defun my/getenv-path()
  "Instead of exec-path!"
  (interactive)
  (condition-case err
      (let ((path (with-temp-buffer
                    (insert-file-contents-literally "~/.emacs.d/.path")
                    (buffer-string))))
        (setenv "PATH" path)
        (setq exec-path (append (parse-colon-path path) (list exec-directory))))
    (error (warn "%s" (error-message-string err)))))

(when (file-exists-p "~/.emacs.d/.path")
  (add-hook 'after-init-hook #'my/getenv-path))

;; format all, formatter for almost languages
;; great for programmers
(use-package format-all
  :ensure t
  :defer t
  :hook (prog-mode . format-all-mode)
  :bind ("C-c f" . #'format-all-region-or-buffer))

;; Protobuf file support
(use-package protobuf-mode
  :ensure t
  :mode "\\.proto\\'")

;; Markdown file support
(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\markdown\\'" . markdown-mode)))

;; Run code
(use-package quickrun
  :ensure t
  :when (derived-mode-p 'prog-mode))

(use-package htmlize
  :ensure t)

(use-package rimel
 :ensure t
 :init
 (setenv "PATH" (concat "/opt/homebrew/bin:" (getenv "PATH")))
 (setenv "CPATH" "/opt/homebrew/include")
 (setenv "LIBRARY_PATH" "/opt/homebrew/lib")
 (setq liberime-auto-build t)
 (setq liberime-user-data-dir "~/Library/Rime")
 (setq default-input-method "rimel"))

 ;; M-x ghostel(d & enter), C-c C-d to close
(use-package ghostel
  :commands ghostel-mode)


(use-package doom-themes
  :ensure t
  :defer t
  :custom
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold nil  ; if nil, bold is universally disabled
	 doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :init
  (add-hook 'emacs-startup-hook
            (lambda ()
              (load-theme 'doom-tokyo-night t))))
              ;;(load-theme 'doom-palenight t))))

(use-package all-the-icons
  :ensure t
  :defer t
  :if (display-graphic-p))

(use-package treemacs
  :ensure t
  :commands treemacs
  :bind (("C-c C-1" . treemacs))
  :init
  (setq treemacs-follow-after-init nil)
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t))

(use-package projectile
  :defer 2
  :config
  (projectile-mode +1)
  ;; (setq projectile-switch-project-action #'my/treemacs-open-current-project-only))
  (setq projectile-switch-project-action 'treemacs-projectile))

(use-package treemacs-projectile
  :after treemacs
  :commands treemacs-projectile)

(defun my/treemacs-open-current-project-only ()
  "Close all projects in Treemacs and open only the current Projectile project."
  (interactive)
  (dolist (project (treemacs-workspace->projects (treemacs-current-workspace)))
    (treemacs-remove-project-from-workspace project))
  (treemacs-add-project-to-workspace
   (projectile-project-root)
   (projectile-project-name))
  (treemacs-select-window))

(use-package treemacs-all-the-icons
  :ensure t
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

(when (display-graphic-p)
  (set-frame-font "Consolas Nerd Font-16" nil t))

(defun my/disable-which-function-in-treemacs ()
  "Inore Which-function-mode in treemacs error."
  (when (derived-mode-p 'treemacs-mode)
    (which-function-mode -1)))

(add-hook 'treemacs-mode-hook #'my/disable-which-function-in-treemacs)

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode)
)

(use-package nerd-icons
  :ensure t
  :defer t)

(use-package doom-modeline
  :defer 1
  :config
  (doom-modeline-mode 1))

(use-package eldoc-box
    :diminish (eldoc-box-hover-at-point-mode)
    :custom
    (eldoc-box-lighter nil)
    (eldoc-box-only-multi-line t)
    (eldoc-box-clear-with-C-g t)
    :custom-face
    (eldoc-box-border ((t (:inherit posframe-border :background unspecified))))
    (eldoc-box-body ((t (:inherit tooltip))))
    :hook ((eglot--managed-mode . eldoc-box-hover-at-point-mode)
           (eldoc-mode . eldoc-box-hover-at-point-mode))
    :config
    (setf (alist-get 'left-fringe eldoc-box-frame-parameters) 8
            (alist-get 'right-fringe eldoc-box-frame-parameters) 8))

(provide 'init-third-packages)

;;; init.el ends here
;;; Local Variables:
;; coding: utf-8
;; byte-compile-warnings: (not unresolved obsolete)
;; End:

;;; init-third-packages.el ends here
