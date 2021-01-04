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


(yas-global-mode)
(add-hook 'yas-minor-mode-hook (lambda () (yas-activate-extra-mode 'fundamental-mode)))

(add-hook 'after-init-hook 'global-hl-line-mode)
;; Highlight corresponding parentheses when cursor is on one
(setq show-paren-delay 0) ;; shows matching parenthesis asap
(show-paren-mode t)

;; Proper line wrapping
(global-visual-line-mode t)

;; global key bindings
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-p") 'switch-to-buffer)

;; Show trailing white spaces
(setq-default show-trailing-whitespace t)

;; Remove useless whitespace before saving a file
(add-hook 'before-save-hook 'whitespace-cleanup)
(add-hook 'before-save-hook (lambda() (delete-trailing-whitespace)))

;; disable toolbar
(tool-bar-mode -1)
(set-default 'truncate-lines t)


;; scroll settings
(setq scroll-preserve-screen-position 1)
(setq scroll-step            1
      scroll-conservatively  10000)


;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; packages
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

(use-package popwin
  :ensure t)

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

(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one)
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

(use-package elpy
  :ensure t
  :custom
  ((elpy-rpc-python-command "python3" "The python command"))
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook (lambda ()
			    (add-hook 'before-save-hook
				      'elpy-black-fix-code nil t))))

(use-package pyvenv
  :ensure t
  :config
  (pyvenv-mode 1))

(use-package projectile
  :ensure t
  :custom
  (projectile-switch-project-action 'projectile-commander)
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (add-to-list 'projectile-globally-ignored-directories ".ccls-cache")
  (add-to-list 'projectile-globally-ignored-directories "debugbuild")
  (add-to-list 'projectile-globally-ignored-directories "builds")
  (projectile-mode +1))

;; (use-package helm-projectile
;;   :ensure t
;;   :config
;;   (helm-projectile-on))

;; (use-package neotree
;;   :ensure t
;;   :custom
;;   (neotree-refresh t)
;;   (neo-window-fixed-size nil)
;;   :config
;;   ;;(global-set-key [f8] 'neotree-toggle)
;;   (global-set-key [f8] 'neotree-projectile-action))

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

(use-package treemacs
  :ensure t
  :bind (("<f8>" . 'treemacs))
  :config
  (progn
    (setq treemacs-width 60)
    (treemacs-follow-mode nil)
    (treemacs-git-mode t)
    (treemacs-filewatch-mode t)
    )
  )

(use-package treemacs-projectile
  :ensure t)

(use-package realgud
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

(use-package org-attach-screenshot
  :ensure t)

(load-file (concat user-emacs-directory "/myscripts/my-projectile.el"))
(put 'narrow-to-region 'disabled nil)

;; cc style

;; This was created by using c-guess-no-install and then c-guess-view
;; https://stackoverflow.com/a/39907217
(c-add-style "my-cc-style"
	     '("linux"
	       (c-basic-offset . 2)	; Guessed value
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
