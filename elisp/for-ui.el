;;;
;;; Customizations for User Interface
;;;
;;; This file contains user interface specific things.
;;;

;;
;; User Interface
;;

;; Hide startup screen
(setq inhibit-startup-screen t)

;; Show line numbers
(global-linum-mode)

;; Show menu bar
(menu-bar-mode t)

;; Increase font size.
;; Play with the :height attribute to change size
(set-face-attribute 'default nil :height 120)

;; No cursor blinking
(blink-cursor-mode 0)

;; Title bar path
;; Full path in the title bar
(setq-default frame-title-format "%b (%f)")

;; Set the width and height of the emacs window in characters.
(setq initial-frame-alist '((top . 0) (left . 0) (width . 130) (height . 40)))

;; Turn of the visual bell.
;;
;; On OS X this disables the yellow warning triangle.
;; https://www.emacswiki.org/emacs/AlarmBell
(setq visible-bell nil)

;; Disable audio bell
(setq ring-bell-function 'ignore)
