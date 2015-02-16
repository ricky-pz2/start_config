(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq column-number-mode t)

(load-theme 'wheatgrass)

;;;org-crypt
;;;Encrypting org files (as per: http://doc.norang.ca/org-mode.html#HandlingEncryption)
(require 'org-crypt)
;;Encrypt all entries before saving
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
(setq org-crypt-key "SOMEGPGKEY")
;;(setq org-crypt-disable-auto-save nil)

(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t))

;;(electric-pair-mode 1)

;; Use shell-like backspace C-h, rebind help to F6
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f6>") 'help-command)
;;(setq too-hardcore-backspace t)
;;(setq too-hardcore-return t)
(global-set-key (kbd "<return>") 'ignore)
(global-set-key (kbd "<backspace>") 'ignore)

(require 'hardcore-mode)
(global-hardcore-mode)
(require 'guru-mode)

;;(require 'google-translate)
;;(require 'google-translate-default-ui)
;;(global-set-key "\C-ct" 'google-translate-at-point)
;;(global-set-key "\C-cT" 'google-translate-query-translate)

(require 'package)
(add-to-list 'package-archives 
    '("marmalade" .
      "http://marmalade-repo.org/packages/"))
(package-initialize)

(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)))
