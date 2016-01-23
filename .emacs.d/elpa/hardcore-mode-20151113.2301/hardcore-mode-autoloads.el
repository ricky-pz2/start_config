;;; hardcore-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (or (file-name-directory #$) (car load-path)))

;;;### (autoloads nil "hardcore-mode" "hardcore-mode.el" (22171 32714
;;;;;;  304043 521000))
;;; Generated autoloads from hardcore-mode.el

(autoload 'hardcore-mode "hardcore-mode" "\
Hardcore emacs minor mode.

\(fn &optional ARG)" t nil)

(defvar global-hardcore-mode nil "\
Non-nil if Global-Hardcore mode is enabled.
See the command `global-hardcore-mode' for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-hardcore-mode'.")

(custom-autoload 'global-hardcore-mode "hardcore-mode" nil)

(autoload 'global-hardcore-mode "hardcore-mode" "\
Toggle Hardcore mode in all buffers.
With prefix ARG, enable Global-Hardcore mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Hardcore mode is enabled in all buffers where
`hardcore-mode' would do it.
See `hardcore-mode' for more information on Hardcore mode.

\(fn &optional ARG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; hardcore-mode-autoloads.el ends here
