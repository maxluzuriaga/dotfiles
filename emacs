;; -*- mode: Emacs-Lisp; -*-

(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))

;; load evil
;; TODO: look at config in https://www.reddit.com/r/emacs/comments/726p7i/evil_mode_and_use_package/
(use-package evil
  :ensure t

  :init
  (setq evil-want-C-u-scroll t)

  :config
  (evil-mode 1)
  (define-key evil-motion-state-map (kbd "C-u") 'evil-scroll-up)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (defun evil-unimpaired/insert-space-above (count)
    (interactive "p")
    (dotimes (_ count) (save-excursion (evil-insert-newline-above))))

  (defun evil-unimpaired/insert-space-below (count)
    (interactive "p")
    (dotimes (_ count) (save-excursion (evil-insert-newline-below))))
  (define-key evil-normal-state-map (kbd "[ SPC") 'evil-unimpaired/insert-space-above)
  (define-key evil-normal-state-map (kbd "] SPC") 'evil-unimpaired/insert-space-below)

  (define-key evil-normal-state-map (kbd "|") 'split-window-right)
  (define-key evil-normal-state-map (kbd "_") 'split-window-below)

  ;; TODO separate into own file
  (defun open-dired-curr-dir ()
    "Opens the current buffer's director in dired and moves cursor to the buffer's file"
    (interactive)
    (when buffer-file-name
      (let ((buf-file buffer-file-name))
	(progn (dired default-directory)
	       (dired-goto-file buf-file)))))

  (define-key evil-normal-state-map (kbd "-") 'open-dired-curr-dir))

(use-package evil-commentary
  :ensure t

  :config
  (evil-commentary-mode))

(use-package helm
  :ensure t

  :config
  (helm-mode 1)
  (helm-autoresize-mode t)
  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "C-x b") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-f") 'helm-find-files))

(use-package projectile
  :ensure t

  :config
  (projectile-mode t))

(use-package helm-projectile
  :ensure t

  :config
  (helm-projectile-on)
  (define-key evil-normal-state-map (kbd "C-p") 'helm-projectile))

(use-package helm-ag
  :ensure t)

(use-package key-chord
  :ensure t

  :config

  ;; Escape insert mode with jk or kj
  (key-chord-mode 1)
  (key-chord-define evil-insert-state-map  "jk" 'evil-normal-state))

;; Load color scheme
(use-package base16-theme
  :ensure t
  :demand t

  :config

  (load-theme 'base16-tomorrow-night t)

  ;; Set the cursor color based on the evil state
  (defvar my/base16-colors base16-tomorrow-night-colors)
  (setq evil-emacs-state-cursor   `(,(plist-get my/base16-colors :base0D) box)
    evil-insert-state-cursor  `(,(plist-get my/base16-colors :base0D) bar)
    evil-motion-state-cursor  `(,(plist-get my/base16-colors :base0E) box)
    evil-normal-state-cursor  `(,(plist-get my/base16-colors :base0B) box)
    evil-replace-state-cursor `(,(plist-get my/base16-colors :base08) bar)
    evil-visual-state-cursor  `(,(plist-get my/base16-colors :base09) box)))

(use-package git-gutter-fringe
  :ensure t

  :config
  (git-gutter-mode))

(use-package magit
  :ensure t)

(use-package spaceline
  :ensure t)

(use-package spaceline-config :ensure spaceline
  :config
  (spaceline-helm-mode 1)
  (spaceline-emacs-theme))

(use-package diminish
  :ensure t

  :config
  (diminish 'helm-mode)
  (diminish 'undo-tree-mode)
  (diminish 'evil-commentary-mode)
  (diminish 'git-gutter-mode)
  (diminish 'projectile-mode))

;; Dired config
(require 'dired-x)
(setq-default dired-omit-files-p t)
(setq dired-omit-files "^#.#$\\|.~$")
(dired-omit-mode)
(setq dired-listing-switches "-alhv")
(setq dired-auto-revert-buffer t)
(define-key dired-mode-map (kbd "-") 'diredp-up-directory)

(use-package dired+
  :ensure t)

(use-package rainbow-delimiters
  :ensure t

  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package org
  :ensure t

  :config
  (setq org-agenda-files '("~/Dropbox/org"))

  (global-set-key (kbd "C-c c") 'org-capture)
  (setq org-default-notes-file "~/Dropbox/org/i.org")
  
  (add-hook 'after-init-hook
  	    '(lambda ()
  	       (org-agenda-list)
  	       (delete-other-windows)))

  ;; TODO figure out a way to have org-habit count up to 2am as previous day

  (add-to-list 'org-modules 'org-habit)
  (setq org-log-into-drawer t)

  (defun normal-mode-org-M-ret ()
    "Used in normal mode to prevent splitting an org mode heading on M-ret"
    (interactive)
    (progn (org-end-of-item-list)
	   (org-meta-return)))

  ;; TODO fix this function ^
  ;;(evil-define-key 'normal org-mode--map (kbd "M-return") 'normal-mode-org-M-ret)

  (setq org-extend-today-until 3)
  (setq org-use-effective-time t))

(use-package evil-org
  :ensure t
  :after org
  :config
  (add-hook 'org-mode-hook 'evil-org-mode)
  (add-hook 'evil-org-mode-hook
            (lambda ()
              (evil-org-set-key-theme '(navigation insert textobjects additional calendar))))

  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package org-journal
  :ensure t

  :config
  (setq org-journal-dir "~/Dropbox/org/journal")
  (setq org-journal-time-format ""))

;; Stop default startup screen
(setq inhibit-startup-screen t)

;; Wrap lines
(global-visual-line-mode 1)

;; Line numbers
(add-hook 'prog-mode-hook 'linum-mode)

;; Highlight current line
(global-hl-line-mode 1)

;; Show matching parents
(show-paren-mode 1)

;; No extra GUI stuff
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;; No bell
(setq ring-bell-function 'ignore)

;; Vim-like scrolling
;; TODO if any problems with scroll jumping, try suggestions here:
;; https://www.emacswiki.org/emacs/SmoothScrolling
(setq scroll-conservatively 10000)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-mode t)
 '(package-selected-packages
   (quote
    (org-journal magit smooth-scrolling go evil-org rainbow-delimiters diminish dired+ spaceline git-gutter-fringe helm-ag projectile helm key-chord use-package evil base16-theme)))
 '(projectile-mode t nil (projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setenv
 "PATH" (concat
   "$HOME/bin:"
   "/bin:"
   "/usr/bin:"
   "/sbin:"
   "/usr/sbin:"
   "/usr/local/bin:"
   "/usr/local/sbin:"
   "/Library/TeX/texbin"))

(set-face-attribute 'default nil :family "Meslo LG M")

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(setq comint-prompt-read-only t)
