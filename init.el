;;; package --- My Emacs config.

;;; Commentary:

;; An attempt at bending Emacs to my will.  Without doing too
;; much bending.

;;; Code:

;;
;; Functions
;;

(defadvice ido-find-file (after find-file-sudo activate)
  "Open write protected file as root.

Advices ido to reopen write protected files with sudo.
TODO: Adapt to new advice mechanism."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun simple-clean-region-or-buffer ()
  "Cleans region if selected, otherwise the whole buffer.

Indents and removes whitespace."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (whitespace-cleanup)
          (message "Cleaned region"))
      (progn
        (indent-region (point-min) (point-max))
        (whitespace-cleanup)
        (message "Cleaned buffer")))))

;;
;; Package management
;;

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

;;
;; Modes
;;

(unless (package-installed-p 'flycheck)
  (package-refresh-contents)
  (package-install 'flycheck))
(add-hook 'after-init-hook #'global-flycheck-mode)

(defvar ido-enable-flex-matching)
(setq ido-enable-flex-matching t)
(defvar ido-everywhere)
(setq ido-everywhere t)
(ido-mode 1)

(unless (package-installed-p 'magit)
  (package-refresh-contents)
  (package-install 'magit))

(unless (package-installed-p 'nyan-mode)
  (package-refresh-contents)
  (package-install 'nyan-mode))
(nyan-mode 1)

(unless (package-installed-p 'restclient)
  (package-refresh-contents)
  (package-install 'restclient))
(add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode))

(unless (package-installed-p 'sly)
  (package-refresh-contents)
  (package-install 'sly))

(unless (package-installed-p 'smex)
  (package-refresh-contents)
  (package-install 'smex))
(global-set-key (kbd "M-x") 'smex)

(unless (package-installed-p 'super-save)
  (package-refresh-contents)
  (package-install 'super-save))

(unless (package-installed-p 'web-mode)
  (package-refresh-contents)
  (package-install 'web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

;;
;; Misc. settings
;;

;; run Lisp under Emacs
(setq inferior-lisp-program "/usr/local/bin/clisp")

;; custom file
(setq custom-file "~/.emacs.s/custom.el")

;; map meta to command key
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; disable tool bar
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; disable scroll bar
(scroll-bar-mode -1)

;; increase font size
(set-face-attribute 'default nil :height 160)

;; display column number in mode line
(column-number-mode nil)

;; bind commenting
(global-set-key (kbd "M-c") 'comment-or-uncomment-region)

;; bind cleaning
(global-set-key (kbd "M-n") 'simple-clean-region-or-buffer)

;; do whitespace cleanup on save
(add-hook 'before-save-hook 'whitespace-cleanup)

;; no tabs
(setq-default indent-tabs-mode nil)

;; no backups
(setq make-backup-files nil)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; show matching parens
(show-paren-mode t)

;; y or n
(defalias 'yes-or-no-p 'y-or-n-p)

;; utf-8 always and forever
(prefer-coding-system 'utf-8)

;; ensure that files end with newline
(setq require-final-newline t)
