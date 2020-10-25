;; Installing this file as ~/.emacs.d/init.el replaces (augments?) ~/.emacs
;; See also ... the variable that changes location of ~/.emacs.d
;; (but you still need one of the above)

;; https://stackoverflow.com/questions/916797/emacs-global-set-key-to-c-tab
(global-set-key [C-tab] 'next-window-any-frame) ;; See also other-frame

;; DO NOT EDIT BELOW HERE

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-save-mode t)
 '(show-trailing-whitespace t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
