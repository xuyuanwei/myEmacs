;; http://alexott.net/en/writings/emacs-devenv/EmacsCedet.html
;; http://www.randomsample.de/cedetdocs/cedet/index.html#Top

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(load-file (concat user-emacs-directory "/plugins/cedet/cedet-devel-load.el"))
;;(load-file (concat user-emacs-directory "/plugins/cedet/contrib/cedet-contrib-load.el"))

(require 'cedet)
(require 'cc-mode)
(require 'semantic)
(require 'semantic/ia)

;; enables global support for Semanticdb
(global-semanticdb-minor-mode 1)

;; activates highlighting of first line for current tag (fucntion,class)
(global-semantic-highlight-func-mode 1)
;; activates highlighting of local names that are the same as same of tag under cursor
(global-semantic-idle-local-symbol-highlight-mode 1)

(semantic-mode 1)

(require 'semantic/canned-configs)
(semantic-load-enable-excessive-code-helpers)
;; Increase the delay before activation
(setq semantic-idle-scheduler-idle-time 10)
;; Don't reparse really big buffers
(setq semantic-idle-scheduler-max-buffer-size 100000)
;; Increase the delay before doing slow work to 2 minutes.
(setq semantic-idle-scheduler-work-idle-time 120)


(define-key cedet-m3-mode-map "\C-c " 'cedet-m3-menu-kbd)

;; #if condition
(setq semantic-c-obey-conditional-section-parsing-flag 1)

(defun alexott/cedet-hook ()
  (local-set-key "\C-c\C-j" 'semantic-ia-fast-jump)
  (local-set-key "\C-c\C-s" 'semantic-ia-show-summary))

(add-hook 'c-mode-common-hook 'alexott/cedet-hook)
(add-hook 'c-mode-hook 'alexott/cedet-hook)
(add-hook 'c++-mode-hook 'alexott/cedet-hook)

;; Enable EDE only in C/C++
(require 'ede)
(global-ede-mode 1)
(ede-enable-generic-projects)

;; use GNU Global
(setq cedet-global-command "global")
(when (cedet-gnu-global-version-check t)
  ;; use gnu global as a back end for database search
  (semanticdb-enable-gnu-global-databases 'c-mode)
  ;; use global to accelerate finding files
  (setq ede-locate-setup-options '(ede-locate-global ede-locate-base))
  )
;; use ID Utils
;(when (cedet-idutils-version-check t)
; (setq ede-locate-setup-options '(ede-locate-idutils ede-locate-base))
; )

;; use CScope
;(when (cedet-cscope-version-check t)
;  (setq ede-locate-setup-options '(ede-locate-cscope ede-locate-base))
;  (semanticdb-enable-cscope-databases)
;  )

(require 'semantic/sb)

;; enable the Seantor keymap in all modes that support semantic parsing 
(add-hook 'semantic-init-hooks 'senator-minor-mode)

(add-hook 'mode-hook
          (lambda ()
            (setq senator-step-at-tag-classes '(function))
            (setq senator-step-at-start-end-tag-classes '(function))
            ))

(load-file (concat user-emacs-directory "/emacsSelfSettings.el"))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(custom-enabled-themes (quote (tsdh-dark)))
 '(ede-project-directories
   (quote
    ("/home/cylinc/clfs/stm32/reference/Micrium_STM3220G-Eval_uCOS-II")))
 '(make-backup-files nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
