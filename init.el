(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(global-hl-line-mode 1)
(global-linum-mode 1)
(column-number-mode 1)
(global-highlight-changes-mode 1)
(global-hi-lock-mode)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq initial-scratch-message "")

;(setq make-backup-files nil)
(setq backup-directory-alist `((".*" . "~/.emacs.d/backup"))
      auto-save-file-name-transforms `((".*" , "~/.emacs.d/backup" t)))

(setq-default indent-tabs-mode nil)
(show-paren-mode t)
(delete-selection-mode t)


(defun open-my-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el")
  (message "init.el opened"))

(global-set-key (kbd "<f2>") 'open-my-init-file)

(defconst demo-packages
  '(
    company
    monokai-theme
    hungry-delete
    helm
    swiper
    smartparens
    projectile
    neotree
    undo-tree
    which-key
    expand-region
    ;counsel
))

(defun install-packages ()
  "Install all required packages."
  (interactive)
  (unless package-archive-contents
    (package-refresh-contents))
  (dolist (package demo-packages)
    (unless (package-installed-p package)
      (package-install package))))

(install-packages)

(load-theme 'monokai t)

(add-to-list 'default-frame-alist
	       '(font . "DejaVu Sans Mono-10"))
(set-default-font "DejaVu Sans Mono-10")


(require 'company)
(global-company-mode 1)
(setq company-idle-delay 0.1)

(require 'hungry-delete)
(hungry-delete-mode 1)

(require 'helm)
(require 'helm-config)
(require 'helm-grep)
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebihnd tab to do persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(define-key helm-grep-mode-map (kbd "<return>")  'helm-grep-mode-jump-other-window)
(define-key helm-grep-mode-map (kbd "n")  'helm-grep-mode-jump-other-window-forward)
(define-key helm-grep-mode-map (kbd "p")  'helm-grep-mode-jump-other-window-backward)

(setq
 helm-scroll-amount 4 ; scroll 4 lines other window using M-<next>/M-<prior>
 helm-ff-search-library-in-sexp t ; search for library in `require' and `declare-function' sexp.
 helm-split-window-in-side-p t ;; open helm buffer inside current window, not occupy whole other window
 helm-candidate-number-limit 500 ; limit the number of displayed canidates
 helm-ff-file-name-history-use-recentf t
 helm-move-to-line-cycle-in-source nil ; move to end or beginning of source when reaching top or bottom of source.
 helm-buffers-fuzzy-matching t          ; fuzzy matching buffer names when non-nil
                                        ; useful in helm-mini that lists buffers
 )



(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c h o") 'helm-occur)
(helm-mode 1)

(avy-setup-default)
(global-set-key (kbd "C-:") 'avy-goto-char)

(require 'helm-gtags)

(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

;; Enable helm-gtags-mode in Dired so you can jump to any tag
;; when navigate project tree with Dired
(add-hook 'dired-mode-hook 'helm-gtags-mode)

;; Enable helm-gtags-mode in Eshell for the same reason as above
(add-hook 'eshell-mode-hook 'helm-gtags-mode)

;; Enable helm-gtags-mode in languages that GNU Global supports
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'java-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(add-hook 'vala-mode-hook 'helm-gtags-mode)

;; key bindings
(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-c g r") 'helm-gtags-find-rtag)
(define-key helm-gtags-mode-map (kbd "C-c g s") 'helm-gtags-find-symbol)
(define-key helm-gtags-mode-map (kbd "C-c g u") 'helm-gtags-update-tags)
(define-key helm-gtags-mode-map (kbd "C-c g c") 'helm-gtags-create-tags)
(define-key helm-gtags-mode-map (kbd "C-c g f") 'helm-gtags-find-files)


(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)


(require 'ggtags)
;(add-hook 'c-mode-common-hook
;          (lambda ()
;            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
;              (ggtags-mode 1))))
;(add-hook 'vala-mode-hook 'ggtags-mode)

(define-key ggtags-mode-map (kbd "C-c g d") 'ggtags-find-definition)
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(require 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching t)

(require 'helm-projectile)
(helm-projectile-on)
(setq projectile-completion-system 'helm)
(setq projectile-indexing-method 'alien)

(require 'neotree)
;; ref: https://www.emacswiki.org/emacs/NeoTree
;;(neotree-mode t)

(setq projectile-switch-project-action 'neotree-projectile-action)

(recentf-mode 1)
(setq recentf-max-saved-items 25)
(global-set-key "\C-x\ \C-r" 'helm-recentf)

;(ivy-mode 1)
;(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-'") 'set-mark-command)
(require 'smartparens-config)
(smartparens-mode t)

(global-undo-tree-mode t)

(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.emacs.d/saved-places")

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

(dtrt-indent-mode t)

(require 'which-key)
(which-key-mode t)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(require 'org)
(setq org-src-fontify-natively t)

(require 'evil)
(evil-mode 1)

(add-hook 'neotree-mode-hook
            (lambda ()
	      (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
	      (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
              (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
              (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

(setq show-trailing-whitespace t)
(setq display-time-24hr-format t)

(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'set-goal-column 'disabled nil)
