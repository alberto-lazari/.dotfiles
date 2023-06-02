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

;; Use "," as agda leader key
(defvar agda-leader (make-sparse-keymap)
  "Keymap for \",\" shortcuts.")
(define-key evil-normal-state-map "," agda-leader)

;; Agda commands (, <key>)
(define-key agda-leader "l" 'agda2-load)
(define-key agda-leader "f" 'agda2-next-goal)
(define-key agda-leader "b" 'agda2-previous-goal)
(define-key agda-leader (kbd "SPC") 'agda2-give)
(define-key agda-leader "r" 'agda2-refine)
(define-key agda-leader "a" 'agda2-auto-maybe-all)
(define-key agda-leader "c" 'agda2-make-case)
(define-key agda-leader "v" 'agda2-compute-normalised-maybe-toplevel)
(define-key agda-leader (kbd "\\") 'describe-char)
(define-key agda-leader (kbd ",") 'agda2-goal-and-context)
(define-key agda-leader (kbd ".") 'agda2-goal-and-context-and-inferred)
(define-key agda-leader (kbd ";") 'agda2-goal-and-context-and-checked)

;; The following are the default commands, still mapped to C-c <key>
;; agda2-compile                           "\C-c\C-x\C-c"
;; agda2-quit                              "\C-c\C-x\C-q"
;; agda2-restart                           "\C-c\C-x\C-r"
;; agda2-abort                             "\C-c\C-x\C-a"
;; agda2-remove-annotations                "\C-c\C-x\C-d"
;; agda2-display-implicit-arguments        "\C-c\C-x\C-h"
;; agda2-display-irrelevant-arguments      "\C-c\C-x\C-i"
;; agda2-show-constraints                  ,(kbd "C-c C-=")
;; agda2-solve-maybe-all                   ,(kbd "C-c C-s")
;; agda2-show-goals                        ,(kbd "C-c C-?")
;; agda2-elaborate-give                    ,(kbd "C-c C-m")
;; agda2-goal-type                         "\C-c\C-t"
;; agda2-show-context                      "\C-c\C-e"
;; agda2-helper-function-type              "\C-c\C-h"
;; agda2-infer-type-maybe-toplevel         "\C-c\C-d"
;; agda2-why-in-scope-maybe-toplevel       "\C-c\C-w"
;; agda2-search-about-toplevel             ,(kbd "C-c C-z")
;; agda2-module-contents-maybe-toplevel    ,(kbd "C-c C-o")
;; agda2-comment-dwim-rest-of-buffer       ,(kbd "C-c C-x M-;")
;; agda2-set-program-version               "\C-c\C-x\C-s"

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
