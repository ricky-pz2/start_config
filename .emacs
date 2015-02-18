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
;;; protbuf.el --- protect buffers from accidental killing

;; Copyright (C) 1994, 1999 Noah S. Friedman

;; Author: Noah Friedman <friedman@splode.com>
;; Maintainer: friedman@splode.com
;; Keywords: extensions
;; Status: Works with emacs 19.23 or later.
;; Created: 1994-06-21

;; $Id: protbuf.el,v 1.7 2000/08/21 10:45:38 friedman Exp $

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package allows you to make it harder to kill buffers accidentally,
;; e.g. by being too trigger happy selecting items in the buffer menu.
;; protect-process-buffer-from-kill-mode is perhaps the more useful of the
;; two, making it harder to accidentally kill shell buffers without
;; terminating the process in them first.

;;; Code:

(defvar protect-buffer-verbose t
  "*If non-nil, print a message when attempting to kill a protected buffer.")

(defvar protect-buffer-bury-p t
    "*If non-nil, bury buffer when attempting to kill it.
This only has an effect if the buffer to be killed is the one
visible in the selected window.")


;;;###autoload
(defvar protect-buffer-from-kill-mode nil
    "*If non-`nil', then prevent buffer from being accidentally killed.
This variable is local to all buffers.")
(progn
  (make-variable-buffer-local 'protect-buffer-from-kill-mode)
  (put 'protect-buffer-from-kill-mode 'permanent-local t)
  (or (assq 'protect-buffer-from-kill-mode minor-mode-alist)
      (setq minor-mode-alist (cons '(protect-buffer-from-kill-mode " prot")
                                   minor-mode-alist))))

;;;###autoload
(defvar protect-process-buffer-from-kill-mode nil
    "*If non-`nil', then protect buffer with live process from being killed.
This variable is local to all buffers.")
(progn
  (make-variable-buffer-local 'protect-process-buffer-from-kill-mode)
  (put 'protect-process-buffer-from-kill-mode 'permanent-local t)
  (or (assq 'protect-process-buffer-from-kill-mode minor-mode-alist)
      (setq minor-mode-alist
            (cons '(protect-process-buffer-from-kill-mode " protp")
                  minor-mode-alist))))

;;;###autoload
(defvar protect-process-buffer-from-kill-preserve-function nil
    "*Function to run to determine whether to kill a process buffer.
If function returns non-nil, buffer is preserved.  Otherwise, the buffer
may be killed.

If this variable is undefined, default action is to test whether a process
object is using this buffer as a process buffer.

This variable is buffer-local when set.")
(make-variable-buffer-local 'protect-process-buffer-from-kill-preserve-function)
(put 'protect-process-buffer-from-kill-preserve-function 'permanent-local t)



;;;###autoload
(defun protect-buffer-from-kill-mode (&optional prefix buffer)
    "Protect buffer from being killed.
To remove this protection, call this command with a negative prefix argument."
    (interactive "P")
    (or buffer (setq buffer (current-buffer)))
    (save-excursion
      ;; Each cond does its own set-buffer *after* comparing prefix just in
      ;; case there's a buffer-local variable `prefix' to screw up the works.
      (cond
       ((null prefix)
        (set-buffer buffer)
        (setq protect-buffer-from-kill-mode
              (not protect-buffer-from-kill-mode)))
       ((>= prefix 0)
        (set-buffer buffer)
        (setq protect-buffer-from-kill-mode t))
       (t
        (set-buffer buffer)
        (setq protect-buffer-from-kill-mode nil)))
      ;; This is always done because kill-buffer-query-functions might have
      ;; been buffer-local when this package was initially loaded, leaving
      ;; the global value unchanged.
      (add-hook 'kill-buffer-query-functions 'protect-buffer-from-kill)))

;; This function is listed in kill-buffer-query-functions; it should return
;; nil if the buffer should not be killed, t otherwise.
(defun protect-buffer-from-kill ()
  (cond
   (protect-buffer-from-kill-mode
    (and protect-buffer-verbose
         (message "Buffer \"%s\" is protected from being killed."
                  (buffer-name)))
    (and protect-buffer-bury-p
         (eq (current-buffer)
             (window-buffer (selected-window)))
         (bury-buffer))
    nil)
   (t)))


;;;###autoload
(defun protect-process-buffer-from-kill-mode (&optional prefix buffer)
    "Protect buffer from being killed as long as it has an active process.
To remove this protection, call this command with a negative prefix argument."
    (interactive "P")
    (or buffer (setq buffer (current-buffer)))
    (save-excursion
      ;; Each cond does its own set-buffer *after* comparing prefix just in
      ;; case there's a buffer-local variable `prefix' to screw up the works.
      (cond
       ((null prefix)
        (set-buffer buffer)
        (setq protect-process-buffer-from-kill-mode
              (not protect-process-buffer-from-kill-mode)))
       ((>= prefix 0)
        (set-buffer buffer)
        (setq protect-process-buffer-from-kill-mode t))
       (t
        (set-buffer buffer)
        (setq protect-process-buffer-from-kill-mode nil)))
      ;; This is always done because kill-buffer-query-functions might have
      ;; been buffer-local when this package was initially loaded, leaving
      ;; the global value unchanged.
      (add-hook 'kill-buffer-query-functions 'protect-process-buffer-from-kill)))

;; This function is listed in kill-buffer-query-functions; it should return
;; nil if the buffer should be protected, t if buffer should be killed.
(defun protect-process-buffer-from-kill ()
  (cond
   ((not protect-process-buffer-from-kill-mode) t)
   ((or (and (boundp 'protect-process-buffer-from-kill-preserve-function)
             protect-process-buffer-from-kill-preserve-function
             (funcall protect-process-buffer-from-kill-preserve-function))
        (get-buffer-process (current-buffer)))
    (and protect-buffer-verbose
         (message "Buffer \"%s\" has live process; not killing."
                  (buffer-name)))
    (and protect-buffer-bury-p
         (eq (current-buffer)
             (window-buffer (selected-window)))
         (bury-buffer))
    nil)
   (t t)))

(add-hook 'kill-buffer-query-functions 'protect-buffer-from-kill)
(add-hook 'kill-buffer-query-functions 'protect-process-buffer-from-kill)

(add-to-list 'load-path "~/.emacs.d/plugins/")
(load "protbuf.el")
(provide 'protbuf)

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

(global-set-key "\M-k" '(lambda () (interactive) (kill-line 0)) )
(setq confirm-nonexistent-file-or-buffer nil)

;; Ido directives
(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)
;(setq ido-enable-tramp-completion nil)
(setq ido-enable-last-directory-history nil)
(setq ido-confirm-unique-completition nil)
(setq ido-show-dot-for-dired t)
(setq ido-use-filename-at-point t)
(setq ido-confirm-unique-completion nil)

;; Use auto complete everywhere
(global-auto-complete-mode t)

(defvar my-local-shells
  '("*shell0*" "*shell1*" "*shell2*" "*shell3*" "*music*"))
(defvar my-remote-shells
  '("*goatshell*" "*barn0*" "*barn1*" "*barn2*" "*barn3*"))
(defvar my-shells (append my-local-shells my-remote-shells))

(require 'tramp)

(custom-set-variables
 '(tramp-default-method "ssh")          ; uses ControlMaster
 '(comint-scroll-to-bottom-on-input t)  ; always insert at the bottom
 '(comint-scroll-to-bottom-on-output nil) ; always add output at the bottom
 '(comint-scroll-show-maximum-output t) ; scroll to show max possible output
 ;; '(comint-completion-autolist t)     ; show completion list when ambiguous
 '(comint-input-ignoredups t)           ; no duplicates in command history
 '(comint-completion-addsuffix t)       ; insert space/slash after file completion
 '(comint-buffer-maximum-size 20000)    ; max length of the buffer in lines
 '(comint-prompt-read-only nil)         ; if this is t, it breaks shell-command
 '(comint-get-old-input (lambda () "")) ; what to run when i press enter on a
                                        ; line above the current prompt
 '(comint-input-ring-size 5000)         ; max shell history size
 '(protect-buffer-bury-p nil)
 )

(setenv "PAGER" "cat")

;; truncate buffers continuously
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(defun make-my-shell-output-read-only (text)
  "Add to comint-output-filter-functions to make stdout read only in my shells."
  (if (member (buffer-name) my-shells)
      (let ((inhibit-read-only t)
            (output-end (process-mark (get-buffer-process (current-buffer)))))
        (put-text-property comint-last-output-start output-end 'read-only t))))
(add-hook 'comint-output-filter-functions 'make-my-shell-output-read-only)

(defun my-dirtrack-mode ()
  "Add to shell-mode-hook to use dirtrack mode in my shell buffers."
  (when (member (buffer-name) my-shells)
    (shell-dirtrack-mode 0)
    (set-variable 'dirtrack-list '("^.*[^ ]+:\\(.*\\)>" 1 nil))
    (dirtrack-mode 1)))
(add-hook 'shell-mode-hook 'my-dirtrack-mode)

; interpret and use ansi color codes in shell output windows
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun set-scroll-conservatively ()
  "Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
  (set (make-local-variable 'scroll-conservatively) 10))
(add-hook 'shell-mode-hook 'set-scroll-conservatively)

;; i think this is wrong, and it buries the shell when you run emacsclient from
;; it. temporarily removing.
;; (defun unset-display-buffer-reuse-frames ()
;;   "Add to shell-mode-hook to prevent switching away from the shell buffer
;; when emacsclient opens a new buffer."
;;   (set (make-local-variable 'display-buffer-reuse-frames) t))
;; (add-hook 'shell-mode-hook 'unset-display-buffer-reuse-frames)

;; make it harder to kill my shell buffers
(require 'protbuf)
(add-hook 'shell-mode-hook 'protect-process-buffer-from-kill-mode)

(defun make-comint-directory-tracking-work-remotely ()
    "Add this to comint-mode-hook to make directory tracking work
while sshed into a remote host, e.g. for remote shell buffers
started in tramp. (This is a bug fix backported from Emacs 24:
http://comments.gmane.org/gmane.emacs.bugs/39082"
    (set (make-local-variable 'comint-file-name-prefix)
         (or (file-remote-p default-directory) "")))
(add-hook 'comint-mode-hook 'make-comint-directory-tracking-work-remotely)

(defun enter-again-if-enter ()
    "Make the return key select the current item in minibuf and shell history isearch.
An alternate approach would be after-advice on isearch-other-meta-char."
    (when (and (not isearch-mode-end-hook-quit)
               (equal (this-command-keys-vector) [13])) ; == return
      (cond ((active-minibuffer-window) (minibuffer-complete-and-exit))
            ((member (buffer-name) my-shells) (comint-send-input)))))
(add-hook 'isearch-mode-end-hook 'enter-again-if-enter)

(defadvice comint-previous-matching-input
    (around suppress-history-item-messages activate)
    "Suppress the annoying 'History item : NNN' messages from shell history isearch.
If this isn't enough, try the same thing with
comint-replace-by-expanded-history-before-point."
    (let ((old-message (symbol-function 'message)))
      (unwind-protect
          (progn (fset 'message 'ignore) ad-do-it)
        (fset 'message old-message))))

(defadvice comint-send-input (around go-to-end-of-multiline activate)
    "When I press enter, jump to the end of the *buffer*, instead of the end of
the line, to capture multiline input. (This only has effect if
`comint-eol-on-send' is non-nil."
    (flet ((end-of-line () (end-of-buffer)))
          ad-do-it))

;; not sure why, but comint needs to be reloaded from the source (*not*
;; compiled) elisp to make the above advise stick.
(load "comint.el.gz")

;; for other code, e.g. emacsclient in TRAMP ssh shells and automatically
;; closing completions buffers, see the links above.

(defun comint-close-completions ()
    "Close the comint completions buffer.
Used in advice to various comint functions to automatically close
the completions buffer as soon as I'm done with it. Based on
Dmitriy Igrishin's patched version of comint.el."
    (if comint-dynamic-list-completions-config
        (progn
          (set-window-configuration comint-dynamic-list-completions-config)
          (setq comint-dynamic-list-completions-config nil))))

(defadvice comint-send-input (after close-completions activate)
  (comint-close-completions))

(defadvice comint-dynamic-complete-as-filename (after close-completions activate)
  (if ad-return-value (comint-close-completions)))

(defadvice comint-dynamic-simple-complete (after close-completions activate)
  (if (member ad-return-value '('sole 'shortest 'partial))
      (comint-close-completions)))

(defadvice comint-dynamic-list-completions (after close-completions activate)
  (comint-close-completions)
  (if (not unread-command-events)
      ;; comint's "Type space to flush" swallows space. put it back in.
      (setq unread-command-events (listify-key-sequence " "))))
