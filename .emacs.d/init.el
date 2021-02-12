;; Installing this file as ~/.emacs.d/init.el replaces (augments?) ~/.emacs
;; See also ... the variable that changes location of ~/.emacs.d
;; (but you still need one of the above).

;; https://stackoverflow.com/questions/916797/emacs-global-set-key-to-c-tab
(global-set-key [C-tab] 'next-window-any-frame) ;; See also other-frame

;; SEE ALSO
;; * ~/.emacs.d/README.txt

;; Authentication required?
;;
;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; better:
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))
;;
;; (setq url-proxy-services
;;    '(("no_proxy" . "^\\(localhost\\|10.*\\|bnymellon.net\\)")
;;      ("http" . "bnym-proxy.bnymellon.net:8080")
;;      ("https" . "bnym-proxy.bnymellon.net:8080")))
;;
;; This seemed just plain wrong, so I gave up at this point:
;; (setq url-http-proxy-basic-auth-storage
;;     (list (list "proxy.com:8080"
;;                 (cons "Input your LDAP UID !"
;;                       (base64-encode-string "LOGIN:PASSWORD")))))
;; SEE ALSO
;; * https://stackoverflow.com/questions/10787087/\
;;   use-elpa-emacs-behind-a-proxy-requiring-authentication

;; DO NOT EDIT BELOW HERE

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(desktop-files-not-to-save "^$")
 '(desktop-save-mode t)
 '(diff-command "C:\\PROGRA~1\\Git\\usr\\bin\\diff.exe")
 '(package-selected-packages
   '(markdown-mode indent-tools yafolding hydra lv s yaml-mode ##))
 '(show-trailing-whitespace t)
 '(vc-make-backup-files t)
 '(version-control t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
