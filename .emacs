;;; dotconf --- Tiago Coutinho's emacs configuration file
;;; Commentary:

;;; Code:

(setq user-full-name "Jose Tiago Macara Coutinho")
(setq user-mail-address "coutinhotiago@gmail.com")

;; I want to skip straight to the scratch buffer. This turns off the splash
;; screen and puts me straight into the scratch buffer. I don't really care
;; to have anything in there either, so turn off the message while we're at it.
;; Since I end up using org-mode most of the time, set the default mode
;accordingly.
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)

;; Emacs starts up with way too much enabled. Turn off the scroll bar,
;; menu bar, and tool bar. There isn't really a reason to have them on.
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(tooltip-mode -1)

(set-face-attribute 'default nil :font "DejaVu Sans Mono-12")

;; Nobody likes to have to type out the full yes or no when Emacs asks.
;; Which it does often. Make it one character.
(defalias 'yes-or-no-p 'y-or-n-p)

;; There's nothing I dislike more than tabs in my files.
;; Make sure I don't share that discomfort with others.
(setq tab-width 4
      indent-tabs-mode nil)

; I have some modifications to the default display. First, a minor tweak
; to the frame title. It's also nice to be able to see when a file actually
; ends. This will put empty line markers into the left hand side.
(setq-default indicate-empty-lines t)
(when (not indicate-empty-lines)
  (toggle-indicate-empty-lines))

;; Oh, and always highlight parentheses. A person could go insane without that.
(show-paren-mode t)

(setq-default show-trailing-whitespace t)

;; Turn on column numbers.
(column-number-mode t)
(global-display-line-numbers-mode t)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


;; Make ESC quit prompts like C-g
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(defun untabify-buffer ()
  "Untabify buffer."
  (interactive)
  (untabify (point-min) (point-max)))

(defun indent-buffer ()
  "Indent buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer."
  (interactive)
  (indent-buffer)
  (untabify-buffer)
  (delete-trailing-whitespace))

(defun cleanup-region (beg end)
  "Remove tmux artifacts from region."
  (interactive "r")
  (dolist (re '("\\\\│\·*\n" "\W*│\·*"))
    (replace-regexp re "" nil beg end)))

;; Initialize package resources
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("elpa" . "https://elpa.gnu.org/packages/") t)

;; activate all the packages (in particular autoloads)
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install use-package on bootstrap
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package ivy
  :diminish
  :config
  (ivy-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;; if fonts don't look ok: M-x all-the-icons-install-fonts
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))
(setq doom-modeline-height 15)
(setq doom-modeline-bar-width 1)

;; Great themes from doom: one, gruvbox, nord, palenight
;; https://peach.melpa.org for theme catalog
(use-package doom-themes)
(load-theme 'doom-one t)

;; Make life easier matching parenthesis
;; Actually does not work well with doom theme
;;(use-package rainbow-delimiters
;;  :hook (prog-mode . rainbow-delimiters-mode))

;; After a key bind delay, show all available options
;; I put a big delay to make sure it does not show up
;; Not very useful so disable it
;;(use-package which-key
;;  :init (which-key-mode)
;;  :diminish which-key-mdode
;;  :config
;;  (setq which-key-idle-delay 1.5))

(use-package auto-complete)
(ac-config-default)

(use-package flycheck)
(global-flycheck-mode)

(use-package flycheck-pyflakes)

(use-package rust-mode)
(add-hook 'rust-mode-hook (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)
(use-package flycheck-rust)

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python3" . python-mode))

;; Enable black
(use-package python-black
  :demand t
  :after python
  :hook (python-mode . python-black-on-save-mode-enable-dwim)
  :bind ("C-." . python-black-buffer))


;; to make this work, lauch emacs from within the python
;; environment you want. In that environment you need to
;; have jedi installed (ex: conda install jedi)
;; also you need to have the jedi epc server installed in
;; emacs: M-x jedi:install-server
;; instructions: http://tkf.github.io/emacs-jedi/
(use-package jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)


;; ===
;; LSP
;; ===

;;(use-package lsp-mode
;;  :commands (lsp lsp-deferred)
;;  :init
;;  (setq lsp-keymap-prefix "C-c l")
;;  :hook
;;  ((python-mode . lsp-deferred))
;;  :commands lsp lsp-deferred)

;;(use-package lsp-ui :commands lsp-ui-mode)
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

;; python LSP from jedi
;;(use-package lsp-jedi
;;  :ensure t
;;  :config
;;  (with-eval-after-load "lsp-mode"
;;    (add-to-list 'lsp-disabled-clients 'pyls)
;;    (add-to-list 'lsp-enabled-clients 'jedi)))


;; python LSP from micro$oft
;;(use-package lsp-python-ms
;;  :ensure t
;;  :init (setq lsp-python-ms-auto-install-server t)
;;  :hook (python-mode . (lambda ()
;;                          (require 'lsp-python-ms)
;;                          (lsp))))  ; or lsp-deferred

;; python LSP from pyright
;;(use-package lsp-pyright
;;  :ensure t
;;  :hook (python-mode . (lambda ()
;;                          (require 'lsp-pyright)
;;                          (lsp))))  ; or lsp-deferred

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (python-black python-mode use-package rust-mode lsp-ui lsp-pyright lsp-jedi lsp-ivy jedi ivy-rich flycheck-rust flycheck-pyflakes doom-themes doom-modeline counsel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide '.emacs)
;;; .emacs ends here
