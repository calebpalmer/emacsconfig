(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
;; use-package

;; move custom-set-variables and custom-set-faces into another file
(setq custom-file (concat user-emacs-directory "/custom.el"))
(load-file custom-file)



;; global key bindings
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-p") 'switch-to-buffer)

;; show trailing white space
;; (add-hook 'hack-local-variables-hook
;; 	  (lambda () (setq show-trailing-whitespace t)))

;; disable toolbar
(tool-bar-mode -1)

;; scroll settings
(setq scroll-preserve-screen-position 1)
(setq scroll-step            1
      scroll-conservatively  10000)


;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(require 'use-package)

(use-package auto-package-update
  :ensure t
  :config
  (auto-package-update-maybe))

(use-package company
  :ensure t
  :config
  (setq company-tooltip-align-annotations t
	company-minimum-prefix-length 1
	company-idle-delay 0.2)
  (global-company-mode))

(use-package helm
  :ensure t
  :bind
  (("C-x C-f" . 'helm-find-files))
  :config
  (require 'helm-config)
  (helm-mode 1)
  )

(use-package lsp-mode
  :ensure t
  :custom
  (lsp-clients-clangd-executable "/usr/bin/clangd-10" "Set clang executable")
  :config
  (setq lsp-prefer-flymake nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (add-hook 'c++-mode-hook 'lsp)
  (add-hook 'c-mode-hook 'lsp))

;; (use-package lsp-treemacs
;;   :ensure t
;;   :config
;;   (lsp-treemacs-sync-mode 1))

(use-package helm-lsp
  :ensure t
  :config
  ;; this is not quite working right.  See https://github.com/emacs-lsp/helm-lspL
  (define-key lsp-mode-map [remap xref-find-apropos] #'helm-lsp-workspace-symbol)
  )

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-doc-enable nil))

(use-package company-lsp
  :ensure t)

;; (use-package dracula-theme
;;   :ensure t
;;   :config
;;   (load-theme 'dracula t)
;;   )

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one)
  )

(use-package elpy
  :ensure t
  :custom
  ((elpy-rpc-python-command "python3" "The python command"))
  :config
  (elpy-enable))

(use-package blacken
  :ensure t
  :config
  (add-hook 'python-mode-hook 'blacken-mode)
  )

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(use-package projectile
  :ensure t
  :custom
  (projectile-switch-project-action 'projectile-dired)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
  (add-to-list 'projectile-globally-ignored-directories "debugbuild")
  (add-to-list 'projectile-globally-ignored-directories "builds")
  (projectile-mode +1))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package neotree
  :ensure t
  :config
  (global-set-key [f8] 'neotree-toggle))

(use-package magit
  :ensure t
  :bind
  (("C-x g" . 'magit-status))  
  :config
  (setq magit-display-buffer-function
      (lambda (buffer)
        (display-buffer
         buffer
         (cond ((and (derived-mode-p 'magit-mode)
                     (eq (with-current-buffer buffer major-mode)
                         'magit-status-mode))
                nil)
               ((memq (with-current-buffer buffer major-mode)
                      '(magit-process-mode
                        magit-revision-mode
                        magit-diff-mode
                        magit-stash-mode))
                nil)
               (t
                '(display-buffer-same-window)))))))

(use-package clang-format+
  :ensure t
  :config
  (add-hook 'c-mode-common-hook #'clang-format+-mode))

(defun cap/c++-mode-hook ()
  (local-set-key (kbd "<f12>") 'compile)
  (local-set-key (kbd "<f9>") 'ff-find-other-file)
  (setq tab-width 4)
  ;; (lsp)
  )

(add-hook 'c++-mode-hook 'cap/c++-mode-hook)
(add-hook 'c-mode-hook 'cap/c++-mode-hook)
(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode))

(use-package yasnippet-snippets
  :ensure t)

(use-package tide
  :ensure t
  :config
  (add-hook 'before-save-hook 'tide-format-before-save)
  (add-hook 'typescript-mode-hook
    	    (lambda ()
		 (tide-setup)
		 (flycheck-mode +1)
		 (setq flycheck-check-syntax-automatically '(save mode-enabled))
		 (eldoc-mode +1)
		 (tide-hl-identifier-mode +1)
		 ;; company is an optional dependency. You have to
		 ;; install it separately via package-install
		 ;; `M-x package-install [ret] company`
		 (company-mode +1))
	    ))

(use-package typescript-mode
  :ensure t
)

;; (use-package ng2-mode
;;   :ensure t
;;   :config
;;   (with-eval-after-load 'typescript-mode (add-hook 'typescript-mode-hook #'lsp))
;;   (add-hook 'typescript-mode-hook 'ng2-ts-mode)
;;   (add-hook 'mhtml-mode-hook 'ng2-html-mode)
;;   )

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  )

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))

(use-package restclient
  :ensure t)

(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package docker
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package docker-compose-mode
  :ensure t)

(use-package ace-window
  :ensure t
  :bind
  (("M-S-o" . 'ace-window)
   ("M-o" . 'ace-window))
  :custom
  (aw-scope 'frame "Only consider the current frame."))

;; (use-package ccls
;;   :ensure t
;;   :hook ((c-mode c++-mode objc-mode cuda-mode) .
;;          (lambda () (require 'ccls) (lsp)))
;;   :config
;;   (setq ccls-executable "/usr/local/bin/ccls"))

(use-package go-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  (add-hook 'go-mode-hook (lambda ()
			    (lsp-deferred))))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; non package scripts
(add-to-list 'load-path "~/.emacs.d/thirdpartyscripts")
(load "gendoxy.el")

;; zoom
(load "zoom-frm.el")
(global-set-key (kbd "C-x C-=") 'zoom-in)
(global-set-key (kbd "C-x C--") 'zoom-out)

;;
(use-package which-key
  :ensure t
  :config
  (setq which-key-popup-type 'frame)
  (which-key-mode))

