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
  (define-key evil-normal-state-map (kbd "] SPC") 'evil-unimpaired/insert-space-below))

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-ag projectile helm key-chord use-package evil base16-theme)))
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
   "/usr/local/sbin"))

(set-face-attribute 'default nil :family "Meslo LG M")
