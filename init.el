(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

;; (require 'ob-tangle)
;; (org-babel-load-file "~/.emacs.d/org_init.org")

;; move custom-set-variables and custom-set-faces into another file
(setq custom-file (concat user-emacs-directory "/custom.el"))
(load-file custom-file)


(yas-global-mode)
(add-hook 'yas-minor-mode-hook (lambda () (yas-activate-extra-mode 'fundamental-mode)))

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; packages
(require 'use-package)

(add-to-list 'load-path "~/.emacs.d/thirdpartyscripts")

(use-package ob-restclient)

(use-package org
  :config
  (setq org-src-preserve-indentation nil
  org-edit-src-content-indentation 0)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((restclient . t)))
  )

(use-package org-attach-screenshot
  :ensure t)

(use-package lsp-mode
  :ensure t
  :custom
  (lsp-clients-clangd-executable "/usr/bin/clangd-10" "Set clang executable")
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-lens-enable nil)
  (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  (add-hook 'c++-mode-hook 'lsp)
  (add-hook 'c-mode-hook 'lsp))

(use-package lsp-ui
  :ensure t
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-delay 0.2)
  (setq lsp-ui-doc-position 'top)
  (setq lsp-ui-doc-use-webkit t)
  (setq lsp-ui-imenu-auto-refresh t)
  (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
  (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))

(use-package company-lsp
  :ensure t)

;;(load-theme 'spacemacs-dark)

(use-package doom-themes
  :ensure t
  :config
  ;;(load-theme 'doom-one)
  ;;(doom-themes-neotree-config) ;; loads doom theme for the file tree Neotree
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Enable all-the-icons beautiful icons for the Neotree doom theme
  ;;(setq doom-neotree-enable-file-icons t)
  ;;(setq doom-neotree-enable-folder-icons t)
  ;;(setq doom-neotree-enable-chevron-icons t)
  ;; Enables different colors for different file types for the Neotree doom theme
  ;;(setq doom-neotree-enable-type-colors t)
  )

(add-hook 'after-init-hook 'global-hl-line-mode)
;; Highlight corresponding parentheses when cursor is on one
(setq show-paren-delay 0) ;; shows matching parenthesis asap
(show-paren-mode t)

;; Proper line wrapping
(global-visual-line-mode t)

;; disable toolbar
(tool-bar-mode -1)
(set-default 'truncate-lines t)


;; scroll settings
(setq scroll-preserve-screen-position 1)
(setq scroll-step            1
      scroll-conservatively  10000)

;; zoom
(load "zoom-frm.el")
(global-set-key (kbd "C-x C-=") 'zoom-in)
(global-set-key (kbd "C-x C--") 'zoom-out)

;; Adds Nice Icons to Emacs so that other themes can use them (required for Doom theme below)
;; run M-x all-the-icons-install-fonts RET to install the fonts
(use-package all-the-icons
  :ensure t)

(use-package smart-mode-line
  :ensure t
  :config
  ;; Smart-mode-line makes the mode-line better to read
  ;; first remove annoying message at startup that
  ;; asks if you want to run the theme lisp code
  (setq sml/no-confirm-load-theme t)
  ;; load smart-mode-line
  ;; (setq sml/theme 'dark) ;; changes the theme to dark
  (sml/setup) ;; automatically figures out a theme if none is specified
  )

(use-package ace-window
  :ensure t
  :bind
  (("M-S-o" . 'ace-window)
   ("M-o" . 'ace-window))
  :custom
  (aw-scope 'frame "Only consider the current frame."))

;; (use-package eyebrowse
;;   :ensure t
;;   :diminish eyebrowse-mode
;;   :config (progn
;;	    (define-key eyebrowse-mode-map (kbd "M-1") 'eyebrowse-switch-to-window-config-1)
;;	    (define-key eyebrowse-mode-map (kbd "M-2") 'eyebrowse-switch-to-window-config-2)
;;	    (define-key eyebrowse-mode-map (kbd "M-3") 'eyebrowse-switch-to-window-config-3)
;;	    (define-key eyebrowse-mode-map (kbd "M-4") 'eyebrowse-switch-to-window-config-4)
;;	    (define-key eyebrowse-mode-map (kbd "M-5") 'eyebrowse-switch-to-window-config-5)
;;	    (define-key eyebrowse-mode-map (kbd "M-6") 'eyebrowse-switch-to-window-config-6)
;;	    (define-key eyebrowse-mode-map (kbd "M-7") 'eyebrowse-switch-to-window-config-7)
;;	    (define-key eyebrowse-mode-map (kbd "M-8") 'eyebrowse-switch-to-window-config-8)
;;	    (eyebrowse-mode t)
;;	    (setq eyebrowse-new-workspace t)))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)
  :config
  (persp-mode))

(put 'narrow-to-region 'disabled nil)

(use-package treemacs
  :ensure t
  :bind (("<f8>" . 'treemacs))
  :config
  (progn
    (setq treemacs-width 60)
    (treemacs-follow-mode nil)
    (treemacs-filewatch-mode t)
    )
  )

(use-package treemacs-projectile
  :ensure t)

(use-package popwin
  :ensure t)

(use-package vscode-dark-plus-theme
  :ensure t
  :config
  (load-theme 'vscode-dark-plus t))

(use-package dired-subtree
  :ensure t
  :config
  (define-key dired-mode-map "i" 'dired-subtree-insert)
  (define-key dired-mode-map ";" 'dired-subtree-remove)
  )

;; Show trailing white spaces
(setq-default show-trailing-whitespace nil)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; global key bindings
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-p") 'switch-to-buffer)

(use-package helm
  :ensure t
  :bind
  (("C-x C-f" . 'helm-find-files)
   ("M-O" . 'helm-occur)
   ("M-x" . 'helm-M-x)
   ("C-x b" . 'helm-buffers-list)
   )
  :config
  (require 'helm-config)
  (helm-mode 1)
  ;; Make helm show on bottom always.
  (add-to-list 'display-buffer-alist
	       `(,(rx bos "*helm" (* not-newline) "*" eos)
		 (display-buffer-in-side-window)
		 (inhibit-same-window . t)
		 (window-height . 0.4))))

(use-package helm-swoop
  :bind (("M-S" . 'helm-swoop)))

(use-package projectile
  :ensure t
  :custom
  (projectile-switch-project-action 'projectile-commander)
  (projectile-current-project-on-switch 'keep)
  :config
  (define-key projectile-mode-map (kbd "M-P") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
  (add-to-list 'projectile-globally-ignored-directories "debugbuild")
  (add-to-list 'projectile-globally-ignored-directories "builds")
  (projectile-mode +1))

(use-package helm-projectile
  :ensure t
  :config
  (helm-projectile-on))

(use-package company
  :ensure t
  :config
  (setq company-tooltip-align-annotations t
	company-minimum-prefix-length 1
	company-idle-delay 0.2)
  (global-company-mode)
  (with-eval-after-load "company"
    (define-key company-active-map (kbd "C-p") #'company-select-previous-or-abort)
    (define-key company-active-map (kbd "C-n") #'company-select-next-or-abort))
  )

(use-package magit
  :ensure t
  :bind
  (("C-x g" . 'magit-status))
  :config
  (setq magit-diff-refine-hunk (quote all))
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

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode))

(use-package yasnippet-snippets
  :ensure t)

(use-package elpy
  :ensure t
  :custom
  ((elpy-rpc-python-command "python3" "The python command"))
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook (lambda ()
			      (add-hook 'before-save-hook
					'elpy-black-fix-code nil t))))

(defun my-python-mode-hook ()
;;   (lsp)
;;  )

;; (add-hook 'python-mode-hook 'my-python-mode-hook)

;; (use-package p
  yvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(use-package blacken
  :config
  (add-hook 'python-mode-hook 'blacken-mode))

(use-package clang-format+
  :ensure t
  :config
  (add-hook 'c-mode-common-hook #'clang-format+-mode))

(defun cap/c++-mode-hook ()
  (local-set-key (kbd "<f12>") 'compile)
  (local-set-key (kbd "<f9>") 'ff-find-other-file)
  (setq tab-width 4)
  (linum-mode t)
  ;; (lsp)
  )

(add-hook 'c++-mode-hook 'cap/c++-mode-hook)
(add-hook 'c-mode-hook 'cap/c++-mode-hook)
(add-to-list 'auto-mode-alist '("\\.tpp\\'" . c++-mode))

;; cc style

;; This was created by using c-guess-no-install and then c-guess-view
;; https://stackoverflow.com/a/39907217
(c-add-style "my-cc-style"
	     '("linux"
	       (c-basic-offset . 4)	; Guessed value
	       (c-offsets-alist
		(arglist-cont . 0)	; Guessed value
		(arglist-intro . ++)	; Guessed value
		(defun-block-intro . +)	; Guessed value
		(defun-close . 0)	; Guessed value
		(defun-open . 0)	; Guessed value
		(innamespace . 0)	; Guessed value
		(namespace-close . 0)	; Guessed value
		(namespace-open . 0)	; Guessed value
		(topmost-intro . 0)	; Guessed value
		(topmost-intro-cont . ++) ; Guessed value
		(access-label . -)
		(annotation-top-cont . 0)
		(annotation-var-cont . +)
		(arglist-close . c-lineup-close-paren)
		(arglist-cont-nonempty . c-lineup-arglist)
		(block-close . 0)
		(block-open . 0)
		(brace-entry-open . 0)
		(brace-list-close . 0)
		(brace-list-entry . c-lineup-under-anchor)
		(brace-list-intro . +)
		(brace-list-open . 0)
		(c . c-lineup-C-comments)
		(case-label . 0)
		(catch-clause . 0)
		(class-close . 0)
		(class-open . 0)
		(comment-intro . c-lineup-comment)
		(composition-close . 0)
		(composition-open . 0)
		(cpp-define-intro c-lineup-cpp-define +)
		(cpp-macro . -1000)
		(cpp-macro-cont . +)
		(do-while-closure . 0)
		(else-clause . 0)
		(extern-lang-close . 0)
		(extern-lang-open . 0)
		(friend . 0)
		(func-decl-cont . +)
		(inclass . +)
		(incomposition . +)
		(inexpr-class . +)
		(inexpr-statement . +)
		(inextern-lang . +)
		(inher-cont . c-lineup-multi-inher)
		(inher-intro . +)
		(inlambda . c-lineup-inexpr-block)
		(inline-close . 0)
		(inline-open . +)
		(inmodule . +)
		(knr-argdecl . 0)
		(knr-argdecl-intro . 0)
		(label . 0)
		(lambda-intro-cont . +)
		(member-init-cont . c-lineup-multi-inher)
		(member-init-intro . +)
		(module-close . 0)
		(module-open . 0)
		(objc-method-args-cont . c-lineup-ObjC-method-args)
		(objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
		(objc-method-intro .
				   [0])
		(statement . 0)
		(statement-block-intro . +)
		(statement-case-intro . +)
		(statement-case-open . 0)
		(statement-cont . +)
		(stream-op . c-lineup-streamop)
		(string . -1000)
		(substatement . +)
		(substatement-label . 0)
		(substatement-open . 0)
		(template-args-cont c-lineup-template-args +))))

(setq c-default-style "my-cc-style")

(use-package go-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  (add-hook 'go-mode-hook (lambda ()
			    (lsp-deferred)
			    (setq tab-width 4))))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package rust-mode
  :config
  (add-hook 'rust-mode-hook
	    (lambda () (progn
			 (setq indent-tabs-mode nil)
			 (lsp))))
  (setq rust-format-on-save t))

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

(use-package web-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  )

;; sudo npm install -g js-beautify
(use-package web-beautify
  :ensure t
  :config
  (eval-after-load 'js2-mode
    '(add-hook 'js2-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  ;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
  (eval-after-load 'js
    '(add-hook 'js-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

  (eval-after-load 'json-mode
    '(add-hook 'json-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  (eval-after-load 'web-mode
    '(add-hook 'web-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))
  (eval-after-load 'css-mode
    '(add-hook 'css-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))

  (eval-after-load 'sgml-mode
    '(add-hook 'html-mode-hook
	       (lambda ()
		 (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))
  )

(use-package emmet-mode
  :ensure t
  :config
  (add-hook 'sgml-mode-hook 'emmet-mode)
  (add-hook 'web-mode-hook 'emmet-mode))

(use-package restclient
  :ensure t)

(use-package docker
  :ensure t)

(use-package dockerfile-mode
  :ensure t)

(use-package docker-compose-mode
  :ensure t)

(use-package yaml-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package groovy-mode)

;; non package scripts
(load "gendoxy.el")

(load-file (concat user-emacs-directory "/myscripts/my-projectile.el"))
