(setq load-prefer-newer t)

(setq byte-compile-warnings '(not free-vars unresolved noruntime lexical make-local))

(defalias 'yes-or-no-p 'y-or-n-p) ; just type y or n for yes and no in prompts
(column-number-mode) ; show the column number in the modeline
(setq-default cursor-in-non-selected-windows nil) ; only show cursor in active window

;; load straight.el for package management
(let ((bootstrap-file
    (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
    (bootstrap-version 4))
(unless (file-exists-p bootstrap-file)
    (load-file (expand-file-name "straight-strap.el" user-emacs-directory)))
(load bootstrap-file nil 'nomessage))

;; configure use-package integration with straight (enable :straight key)
(straight-use-package 'use-package)
(require 'use-package)
(require 'straight)
(setq straight-use-package-by-default t)
;; don't check for modifications on startup -- has a big impact on load time
(setq straight-check-for-modifications 'live)
(setq straight-cache-autoloads t)

(defvar leader-key "SPC")

(defun reload-config ()
    (interactive)
    (straight-transaction
	(straight-mark-transaction-as-init)
	(load-file "~/.emacs.d/init.el")
	(message "Reloading config... done.")))
    
(defun edit-config ()
    (interactive)
    (find-file "~/.emacs.d/init.el"))


;; PACKAGES

;; surrender to vi, vi, vi, the editor of the beast!
(use-package evil
  :demand t
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil) ;; no keybindings, let evil-collection do it
  :config
  (evil-mode 1))

;; bring vi keybindings to (nearly) everything
(use-package evil-collection
  :demand t
  :after evil
  :custom
  (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

(use-package general
  :demand t
  :config
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix leader-key
   :non-normal-prefix "C-SPC"

   ;; Top level
   "R"   '(reload-config :which-key "reload emacs")
   "?"   '(iterm-goto-filedir-or-home :which-key "iterm - goto dir")
   "/"   '(counsel-ag :which-key "counsel search")
   ";"   '(counsel-M-x :which-key "M-x")
   "SPC" '(switch-to-other-buffer :which-key "prev buffer")
   "." '(avy-goto-word-or-subword-1  :which-key "go to char")

   ;; Files
   "f"  '(:ignore t :which-key "Files")
   "ff" '(counsel-find-file :which-key "find file")
   "fs" '(swiper :which-key "search in file")
   "fe" '(edit-config :which-key "edit emacs config")

   ;; Buffers
   "b"  '(:ignore t :which-key "Buffers")
   "bb" '(ivy-switch-buffer :which-key "swap buffer")

   ;; Applications
   "a" '(:ignore t :which-key "Applications")
   "ae" '(eshell :which-key "eshell")
   "as" '(shell :which-key "shell")
   
   ;; Toggles
   "t" '(:ignore t :which-key "Toggles")
   "td" '(toggle-debug-on-error :which-key "debug on error")
   "tn" '(linum-mode :which-key "line numbers")

   ;; Windows
   "w"  '(:ignore t :which-key "Windows")
   "w/" '(evil-window-vsplit :which-key "vsplit")
   "w-" '(evil-window-split :which-key "split")
   "wj" '(evil-window-down :which-key "nav down")
   "wk" '(evil-window-up :which-key "nav up")
   "wh" '(evil-window-left :which-key "nav left")
   "wl" '(evil-window-right :which-key "nav right")
   "wJ" '(evil-window-move-very-bottom :which-key "move down")
   "wK" '(evil-window-move-very-top :which-key "move up")
   "wH" '(evil-window-move-far-left :which-key "move left")
   "wL" '(evil-window-move-far-right :which-key "move right")
   ))

(use-package doom-themes
    :preface (defvar region-fg nil) ;workaround
    :config
    (load-theme 'doom-dracula t)
    (doom-themes-visual-bell-config)
    (doom-themes-org-config))
    
(use-package solaire-mode
    :hook ((change-major-mode after-revert ediff-prepare-buffer) . turn-on-solaire-mode)
    :config
  (add-hook 'minibuffer-setup-hook #'solaire-mode-in-minibuffer)
  (solaire-mode-swap-bg))
 
(use-package eldoc-eval :demand t)
(use-package shrink-path :demand t)
(use-package all-the-icons :demand t)

(use-package doom-modeline
    :demand t
    :straight (:host github :repo "seagle0128/doom-modeline" :branch "master")
    :hook (after-init . doom-modeline-mode)
    :config
    (setq doom-modeline-height 16)
    (setq doom-modeline-bar-width 4))

(use-package no-littering
 :demand t
 :config
 (progn
   (require 'no-littering)
   (require 'recentf)
   (setq no-littering-etc-directory (expand-file-name "etc/" user-emacs-directory))
   (setq no-littering-var-directory (expand-file-name "var/" user-emacs-directory))
   (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
   (setq custom-file (expand-file-name "custom.el" user-emacs-directory))
   (add-to-list 'recentf-exclude no-littering-var-directory)
   (add-to-list 'recentf-exclude no-littering-etc-directory)))

(use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

(global-eldoc-mode 1)
(use-package eldoc-overlay
    :straight (:host github :repo "stardiviner/eldoc-overlay" :branch "master")
    :hook (prog-mode . eldoc-overlay-enable)
    :config
    (setq eldoc-overlay-backend 'posframe))

(use-package which-key
  :demand t
  :diminish which-key-mode
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-sort-order 'which-key-prefix-then-key-order)
  (setq which-key-popup-type 'side-window
	which-key-side-window-max-height 0.5
	which-key-side-window-max-width 0.33
	which-key-idle-delay 0.5
	which-key-min-display-lines 7))
(evil-collection-which-key-setup)

(use-package ivy
  :demand t
  :config
  ;; Escape from ivy-minibuffer in one press, not three. (???)
  (define-key ivy-minibuffer-map [escape] 'minibuffer-keyboard-quit)
  (setq ivy-height 15
	ivy-wrap t
	projectile-completion-system 'ivy
	ivy-initial-inputs-alist nil ;; Don't prefix everything with ^
	ivy-format-function #'ivy-format-function-line))
  
(use-package ivy-posframe
  :config
  (setq ivy-fixed-height-minibuffer nil
	ivy-display-functions-alist (append ivy-display-functions-alist
					'((swiper . nil)
					    (counsel-rg . nil)
					    (counsel-ag . nil)
					    (t . ivy-posframe-display-at-frame-center))))
  (ivy-posframe-enable))

(use-package ivy-rich
  :after ivy
  :config
  (setq ivy-virtual-abbreviate 'full
        ivy-rich-ivy-rich-path-style 'abbrev))

(use-package counsel-projectile)
(use-package counsel
  :demand t)
(use-package amx
  :demand t)

(use-package swiper
  :commands (swiper swiper-all))

(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-collapse-dirs              (if (executable-find "python") 3 0)
	treemacs-file-event-delay           5000
	treemacs-follow-after-init          t
	treemacs-recenter-distance   0.1
	treemacs-goto-tag-strategy          'refetch-index
	treemacs-indentation                2
	treemacs-indentation-string         " "
	treemacs-is-never-other-window      nil
	treemacs-no-png-images              t
	treemacs-project-follow-cleanup     nil
	treemacs-persist-file               (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
	treemacs-recenter-after-file-follow nil
	treemacs-recenter-after-tag-follow  nil
	treemacs-show-hidden-files          t
	treemacs-silent-filewatch           nil
	treemacs-silent-refresh             nil
	treemacs-sorting                    'alphabetic-desc
	treemacs-space-between-root-nodes   t
	treemacs-tag-follow-cleanup         t
	treemacs-tag-follow-delay           1.5
	treemacs-width                      35)
    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t))
(use-package treemacs-evil
  :after treemacs evil)

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package magit
  :commands (magit-status magit-blame magit-log-buffer-file magit-log-all))

(use-package projectile
  :demand t)

(use-package company
  :config
  (global-company-mode)
  (setq company-tooltip-limit 10)
  (setq company-dabbrev-downcase 0)
  (setq company-idle-delay 0.1)
  (setq company-echo-delay 0.1)
  (setq company-minimum-prefix-length 1)
  (setq company-require-match nil)
  (setq company-selection-wrap-around t)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-flip-when-above t))

(use-package lsp-mode
    :commands lsp
    :config
    (use-package lsp-ui
        :commands lsp-ui-mode
	:hook (lsp-ui-mode . (lambda () (setq-local eldoc-documentation-function #'ignore)))
	:config
	(setq lsp-ui-flycheck-live-reporting nil
	      lsp-ui-sideline-code-actions-prefix "💡 "
	      lsp-ui-sideline-ignore-duplicate t
	      lsp-ui-sideline-show-symbol nil
	      lsp-ui-sideline-delay 1.0
	      lsp-ui-doc-include-signature t
	      lsp-ui-doc-header nil))
    (use-package company-lsp
        :commands company-lsp
	:init
	(setq company-transformers nil ; no client-side filter, let LSP server do it
		company-lsp-async t ; force async requests from LSP
		company-lsp-cache-candidates 'auto)
	(push 'company-lsp company-backends))
    (add-hook 'js2-mode-hook  #'lsp)
    (add-hook 'typescript-mode-hook  #'lsp)
    (add-hook 'sh-mode-hook #'lsp)
    (add-hook 'html-mode-hook #'lsp)
    (add-hook 'css-mode-hook  #'lsp)
    (add-hook 'less-mode-hook #'lsp)
    (add-hook 'sass-mode-hook #'lsp)
    (add-hook 'scss-mode-hook #'lsp))

(use-package omnisharp
  :straight (:host github :repo "OmniSharp/omnisharp-emacs" :branch "master")
  :init
  (add-hook 'csharp-mode-hook 'my-csharp-mode)
  (custom-set-variables
   '(omnisharp-company-sort-results t)
   '(omnisharp-auto-complete-want-documentation nil)
   '(omnisharp-company-strip-trailing-brackets nil)
   )
  :config
  (defvar evil-normal-state-map)
  (add-to-list 'auto-mode-alist '("\\.cs$" . csharp-mode))
  (setq omnisharp-company-do-template-completion t)
  (defun omnisharp-unit-test (mode)
    "Run tests after building the solution. Mode should be one of 'single', 'fixture' or 'all'"
    (interactive)
    (let ((build-command
           (omnisharp-post-message-curl
            (concat (omnisharp-get-host) "buildcommand") (omnisharp--get-common-params)))
          (test-command
           (cdr (assoc 'TestCommand
                       (omnisharp-post-message-curl-as-json
                        (concat (omnisharp-get-host) "gettestcontext")
                        (cons `("Type" . ,mode) (omnisharp--get-common-params)))))))

      (compile (concat (replace-regexp-in-string "\n$" "" build-command) " && " test-command)))))

(defun my-elisp-eldoc-function ()
"Wrap `elisp-eldoc-documentation-function` and enrich it with the first line of the function docstring"
    (let* ((fnsym (car (elisp--fnsym-in-current-sexp)))
	(doc-string (ignore-errors (documentation fnsym)))
	(doc-first-line (car (ignore-errors (split-string doc-string "\n")))))
	(if doc-first-line
	    (concat (elisp-eldoc-documentation-function) "\n\n" (symbol-name fnsym) ":\n" doc-first-line)
	    (or (elisp-eldoc-documentation-function) ""))))

(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (setq-local eldoc-documentation-function #'my-elisp-eldoc-function)))

(add-hook 'org-src-mode-hook
	  (lambda ()
	    (when (eq major-mode 'emacs-lisp-mode)
	      (setq-local eldoc-documentation-function #'my-elisp-eldoc-function))))

(use-package lua-mode
    :straight (:host github :repo "immerrr/lua-mode" :branch "master")
    :mode "\\.lua\\'"
    :interpreter "lua")

(use-package monroe)

(use-package fennel-mode
    :straight (:host gitlab :repo "technomancy/fennel-mode" :branch "master"))

;(use-package friar 
;:straight (:host github :repo "warreq/friar" :branch "master"))

(use-package lsp-pwsh
  :straight (lsp-pwsh
             :host github
             :repo "kiennq/lsp-powershell")
  :hook (powershell-mode . (lambda () (require 'lsp-pwsh) (lsp)))
  :defer t)

(use-package typescript-mode
    :commands typescript-mode
    :mode "\\.\\(js\\|jsx\\|ts\\|tsx\\)\\'"
    :hook '((typescript-mode . flycheck-mode)
           (typescript-mode . #'lsp )))

(use-package add-node-modules-path
    :hook (typescript-mode . #'add-node-modules-path ))
    
(use-package prettier-js
    :hook (typescript-mode . prettier-js-mode)
    :config (setq prettier-js-show-errors nil))

;; lower gc threshold back to normal
(setq gc-cons-threshold 16777216
      gc-cons-percentage 0.1)
(defun display-startup-echo-area-message ()
(message "Initialization completed in %s." (emacs-init-time)))
