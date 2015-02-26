;;(custom-set-variables
;;'(inhibit-startup-screen t))

;; General Notes about this .emacs
;; 1. It loads wheatgrass theme by default, 
;;    if you don't want this or want to change this comment out/edit line 29
;; 2. Adds melpa marmalade and org repos by default
;; 3. It checks for packages that should be installed by default (Depending on user).
;;    You can edit packages starting in line 51
;; 4. It adds electricpair by default, autocompletes "", {}, [], ()
;; 5. It adds C-h to delete one char backwards. Uses F6 for help instead
;; 6. Uses M-k to delete line backwards
;; 7. Uses F8 to initialize a M-x session
;; 8. Uses C-c t to use google to translate a region
;; 9. Uses C-c T to translate (doesn't depend on region)
;;10. Use M-x google-this (tab to complete commands) to use google from emacs.

(custom-set-faces
 )

;; Definition for tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)
(setq column-number-mode t)

;; This is my favorite theme, you can change wheatgrass for anything else.
;; If you want the default then just comment this line out
(load-theme 'wheatgrass)

;;;org-crypt
;;;Encrypting org files (as per: http://doc.norang.ca/org-mode.html#HandlingEncryption)
(require 'org-crypt)

(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance (quote ("crypt")))
;; GPG key to use for encryption
(setq org-crypt-key "624787A7")
;;(setq org-crypt-disable-auto-save nil)

;; This is a way to set the emacs repositories
(setq package-archives
      '(("melpa" . "http://melpa.milkbox.net/packages/")
        ("marmalade" . "http://marmalade-repo.org/packages/")
        ("org" . "http://orgmode.org/elpa/")))
(package-initialize)

;; We can check for all packages in emacs to be loaded by default.
(setq core-packages
      '(;;list of packages you want
        bind-key
        magit
        nyan-mode
        projectile
        rainbow-delimiters
        hardcore-mode
        guru-mode
        nginx-mode
        auto-complete
        google-this
        google-translate
        howdoi
        ipretty
        markdown-mode
        nginx-mode
        org
        org-gcal
        org-jekyll
        org-pandoc
        hackernews
        ))

;; If the package don't exist install them
(unless package-archive-contents
  (package-refresh-contents))

(defun ensure-packages (packages)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))
(ensure-packages core-packages)

;; This allaws for the aut completition of "" and () [] {}
(electric-pair-mode 1)

;; Use shell-like backspace C-h, rebind help to F6
(define-key key-translation-map [?\C-h] [?\C-?])
(global-set-key (kbd "<f6>") 'help-command)


;; This will allow you to navigate emacs the right way.
;; It is annoying at first, but I recomend it
;(require 'hardcore-mode)
;(global-hardcore-mode)
;(require 'guru-mode)

;; Google translate
(require 'google-translate)
(require 'google-translate-default-ui)

;; You can highlight a region, and use C-c t to translate from a language to another
(global-set-key "\C-ct" 'google-translate-at-point)
;; You can use C-c T and it will ask for source language to target language.
;;Then it asks for input on what to translate
(global-set-key "\C-cT" 'google-translate-query-translate)

;; Kill backwards
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

;; Defining local shells
;; Moste of the configuration below here is for M-x shell
(defvar my-local-shells
  '("*shell0*" "*shell1*" "*shell2*" "*shell3*"))
(defvar my-remote-shells
  '("*shell*" "*lshell0*" "*lshell1*" "*lshell2*" "*lshell3*"))
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
 '(inhibit-startup-screen t)
 )

(setenv "PAGER" "cat") ;This is to show how to make enviroments

;; truncate buffers continuously
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

(defun make-my-shell-output-read-only (text)
;  "Add to comint-output-filter-functions to make stdout read only in my shells."
  (if (member (buffer-name) my-shells)
      (let ((inhibit-read-only t)
            (output-end (process-mark (get-buffer-process (current-buffer)))))
        (put-text-property comint-last-output-start output-end 'read-only t))))
(add-hook 'comint-output-filter-functions 'make-my-shell-output-read-only)

(defun my-dirtrack-mode ()
;  "Add to shell-mode-hook to use dirtrack mode in my shell buffers."
  (when (member (buffer-name) my-shells)
    (shell-dirtrack-mode 0)
    (set-variable 'dirtrack-list '("^.*[^ ]+:\\(.*\\)>" 1 nil))
    (dirtrack-mode 1)))
(add-hook 'shell-mode-hook 'my-dirtrack-mode)

; interpret and use ansi color codes in shell output windows
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(defun set-scroll-conservatively ()
;  "Add to shell-mode-hook to prevent jump-scrolling on newlines in shell buffers."
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

(add-to-list 'load-path "~/.emacs.d/plugins/")
(load "protbuf.el")

(require 'protbuf)
(add-hook 'shell-mode-hook 'protect-process-buffer-from-kill-mode)

(defun make-comint-directory-tracking-work-remotely ()
;    "Add this to comint-mode-hook to make directory tracking work
;while sshed into a remote host, e.g. for remote shell buffers
;started in tramp. (This is a bug fix backported from Emacs 24:
;http://comments.gmane.org/gmane.emacs.bugs/39082"
    (set (make-local-variable 'comint-file-name-prefix)
         (or (file-remote-p default-directory) "")))
(add-hook 'comint-mode-hook 'make-comint-directory-tracking-work-remotely)

(defun enter-again-if-enter ()
;    "Make the return key select the current item in minibuf and shell history isearch.
;An alternate approach would be after-advice on isearch-other-meta-char."
    (when (and (not isearch-mode-end-hook-quit)
               (equal (this-command-keys-vector) [13])) ; == return
      (cond ((active-minibuffer-window) (minibuffer-complete-and-exit))
            ((member (buffer-name) my-shells) (comint-send-input)))))
(add-hook 'isearch-mode-end-hook 'enter-again-if-enter)

(defadvice comint-previous-matching-input
    (around suppress-history-item-messages activate)
;    "Suppress the annoying 'History item : NNN' messages from shell history isearch.
;If this isn't enough, try the same thing with
;comint-replace-by-expanded-history-before-point."
    (let ((old-message (symbol-function 'message)))
      (unwind-protect
          (progn (fset 'message 'ignore) ad-do-it)
        (fset 'message old-message))))

;(defadvice comint-send-input (around go-to-end-of-multiline activate)
;    "When I press enter, jump to the end of the *buffer*, instead of the end of
;the line, to capture multiline input. (This only has effect if
;; \`\comint-eol-on-send' is non-nil."
;    (flet ((end-of-line () (end-of-buffer)))
;          ad-do-it))

;; ;; not sure why, but comint needs to be reloaded from the source (*not*
;; ;; compiled) elisp to make the above advise stick.
;; (load "comint.el.gz")

;; ;; for other code, e.g. emacsclient in TRAMP ssh shells and automatically
;; ;; closing completions buffers, see the links above.

(defun comint-close-completions ()
;    "Close the comint completions buffer.
;Used in advice to various comint functions to automatically close
;the completions buffer as soon as I'm done with it. Based on
;Dmitriy Igrishin's patched version of comint.el."
 
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

(global-set-key [f8] 'create-shell)

(defun create-shell ()
  "creates a shell with a given name"
  (interactive);; "Prompt\n shell name:")
  (let ((shell-name (read-string "shell name: " nil)))
        (shell (concat "*" shell-name "*"))))

<<<<<<< HEAD

(add-to-list 'auto-mode-alist '("\\.py\\'" . hs-minor-mode))
(add-hook 'c-mode-common-hook 'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook 'hs-minor-mode)
(add-hook 'java-mode-hook 'hs-minor-mode)
(add-hook 'lisp-mode-hook 'hs-minor-mode)
(add-hook 'perl-mode-hook 'hs-minor-mode)
(add-hook 'sh-mode-hook 'hs-minor-mode)
(add-hook 'python-mode-hook 'hs-minor-mode)
(put 'erase-buffer 'disabled nil)
=======
(setq inferior-lisp-program "clisp")
>>>>>>> a77e5cf6d5dd56ed1e22cb392b17ec7deab6c610
