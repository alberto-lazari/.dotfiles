;; Don't show the splash screen
(setq inhibit-startup-message t)
;; Disable blinking cursor
(blink-cursor-mode 0)
;; Relative line numbers
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
;; Scroll line by line
(setq scroll-conservatively 101
      scroll-margin 2)
;; Current line highlighting
(global-hl-line-mode 1)
;; Enable mouse support
(unless (display-graphic-p)
  (xterm-mouse-mode 1)
  ;; Activate mouse-based scrolling
  (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
  (global-set-key (kbd "<mouse-5>") 'scroll-up-line))
;; Disable menu bar mode
(menu-bar-mode -1)

;; Put backup files neatly away (from: https://emacs.stackexchange.com/a/36)
(let ((backup-dir "~/.emacs.d/backups")
      (auto-saves-dir "~/.emacs.d/auto-saves/"))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-directory-alist `(("." . ,backup-dir))
        auto-save-file-name-transforms `((".*" ,auto-saves-dir t))
        auto-save-list-file-prefix (concat auto-saves-dir ".saves-")
        tramp-backup-directory-alist `((".*" . ,backup-dir))
        tramp-auto-save-directory auto-saves-dir))

(setq backup-by-copying t    ; Don't delink hardlinks
      delete-old-versions t  ; Clean up the backups
      version-control t      ; Use version numbers on backups,
      kept-new-versions 5    ; keep some new versions
      kept-old-versions 2)   ; and some old ones, too


(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))

;; Enable use-package
(package-initialize)
(setq use-package-always-ensure t)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))

;; One Dark theme
(use-package one-themes
  :init
  (load-theme 'one-dark t))

;; Vim Bindings
(use-package evil
  :demand t
  :bind (("<escape>" . keyboard-escape-quit))
  :init
  (setq evil-want-keybinding nil
        ;; Redo with C-r
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

;; Vim Bindings Everywhere else
(use-package evil-collection
  :after evil
  :config
  (setq evil-want-integration t)
  (evil-collection-init))

(use-package simple-modeline
  :hook (after-init . simple-modeline-mode))

;; Evil cursor change
(use-package evil-terminal-cursor-changer
  :init
  (etcc-on))

;; Vim-surround plugin for evil
(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

;; Auto closing parenthesis
(electric-pair-mode t)

;; Agda mode
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; Enable expression eval in agda
(global-set-key (kbd "C-c C-v") 'agda2-compute-normalised-maybe-toplevel)
(add-hook 'agda2-mode-hook
          #'(lambda () (define-key (current-local-map) (kbd "C-u") (lookup-key (current-local-map) (kbd "C-c")))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(evil-terminal-cursor-changer simple-modeline evil-collection evil one-themes use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
