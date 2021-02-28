;;; init.el --- bnbeckwith config -*- eval: (read-only-mode 1) -*-
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
(package-initialize)

(require 'ob-tangle)
(org-babel-load-file "~/.emacs.d/org_init.org")
