;;;
;;; Customizations for eshell
;;;

(require 'eshell)

;; Allow eshell to modify the global environment. This is needed so that when
;; we switch python virutal environments this change also shows up in Eshell.
(setq eshell-modify-global-environment t)

(defvar custom-eshell-path-env)
(setq custom-eshell-path-env eshell-path-env)

;; This is a hack to get Eshell to respect the bin folder from
;; the Python virtual environment.
(defun custom-eshell-mode-hook ()
"Set the eshell-path-env to the current custom version.
The custom-eshell-path-env is updated whenever you switch virtual
environments."
  (setq eshell-path-env custom-eshell-path-env))

(add-hook 'eshell-mode-hook 'custom-eshell-mode-hook)

;; The quit function allows us to execute the quit command
;; in eshell to close the eshell buffer and window.
;; Remember that in eshell you can run functions without
;; using parenthesis.

(defun quit ()
"Kill the current buffer and window by typing quit in eshell.
This might be better as an Eshell alias."
  (kill-buffer-and-window))

;; (eshell t) will create a new eshell with the next eshell index number.

;; This one is kind of interesting.
;; (eshell <num>) will do one of two things.
;; If an eshell with index number <num> already exists then switch the
;; window to that buffer.
;; Otherwise create a new eshell with the given index number and show
;; it in the current window.

(defun eshell-below ()
  (interactive)
  (progn
    (split-window-below)
    (other-window 1)
    (eshell t)
    (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)))

(defun eshell-right ()
  (interactive)
  (progn
    (split-window-right)
    (other-window 1)
    (eshell t)
    (set-process-query-on-exit-flag (get-buffer-process (current-buffer)) nil)))

;; Change the prompt we have to set the eshell-prompt-function variable
;; to something that generates a nice prompt. Currently it is very basic.

;; TODO: There is a macro called with-face on the EmacsWiki

(defun prompt-color (text color)
"Set the foreground color of the given TEXT to COLOR."
  (propertize text 'face `(:foreground color)))

;;(defmacro with-foreground (str color)
;;  "Prompertice a string
;;  `(propertize ,str 'face (list ,@properties)))

(defun custom-eshell-prompt-virtualenv ()
"The following will find the name of the current virtual environment.
If there is no current virtual environment return a blank string."
  (let ((venv-path (getenv "VIRTUAL_ENV")))
    (if (s-blank? venv-path)
      ""
      (propertize
        (concat (car (last (s-split "/" venv-path))) " ")
        'face `(:foreground "green")))))

(defun custom-eshell-prompt-location ()
"Return user@hostname."
  (concat (user-login-name) "@" (hostname) " "))

(defun custom-eshell-prompt-char ()
"Return the prompt character.
For non root users this is $.  For the root user this is #."
  (prompt-color
    (if (= (user-uid) 0) "\n# " "\n$ ")
    "white"))

(defun custom-eshell-prompt-git-branch ()
  "Return the current git branch."
  (concat (magit-get-current-branch) " "))

(defun custom-eshell-prompt-path ()
  "Return the current path."
  (prompt-color
    (abbreviate-file-name (eshell/pwd))
    "green"))

;; The next issue is if there is a getenv function that gets the value from the local
;; environment. I.e. gets the value from the remote server when you are logged into
;; a remote server?

(defun custom-eshell-prompt-function ()
  "Custom Eshell prompt."
  (concat
    (custom-eshell-prompt-virtualenv)
    (custom-eshell-prompt-location)
    (custom-eshell-prompt-git-branch)
    (custom-eshell-prompt-path)
    (custom-eshell-prompt-char)))

;; Use customize-set-variable instead of setq when setting variables created
;; by defcustom.
(customize-set-variable 'eshell-prompt-function 'custom-eshell-prompt-function)

;; If we have a multiline prompt then the regexp only needs to match the last
;; line in the prompt.
(customize-set-variable 'eshell-prompt-regexp "[$#] ")

(provide 'for-eshell.el)
;;; for-eshell ends here
