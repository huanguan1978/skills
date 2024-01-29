(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))


;; (server-start)
;; (setq default-tab-width 4)

;;(set-language-environment 'utf-8)
;;(prefer-coding-system 'utf-8-auto)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(leuven))
 '(ede-project-directories '("/home/kaguya/Projects/cede" "/home/kaguya/Projects/c11"))
 '(global-display-line-numbers-mode t)
 '(global-whitespace-mode t)
 '(package-selected-packages
   '(magit markdown-mode yasnippet yasnippet-classic-snippets web-mode php-mode ggtags elpy use-package))
 '(php-mode-hook '(subword-mode flymake-mode))
 '(markdown-command "/usr/bin/pandoc")
 '(c-mode-common-hook
          '(lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
 '(use-short-answers t)
 '(warning-suppress-types '((comp)))
 '(whitespace-line-column 250)
 '(yas-global-mode t))
'(indent-tabs-mode t)
'(c-indent-level 4)
'(c-basic-offset 4)
'(tab-width 4)
'(c-tab-always-indent t)
'(c-default-style "linux")
 '(c-set-style "linux")
 '(php-executable "/usr/bin/php")
 '(php-manual-url 'zh)
 '(php-mode-coding-style 'pear)
 '(php-mode-template-compatibility nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (when (eq system-type 'windows-nt)
;;   (setq gc-cons-threshold (* 512 1024 1024))
;;   (setq gc-cons-percentage 0.5)
;;   (run-with-idle-timer 10 t #'garbage-collect)
;;   (setq garbage-collection-messages t)
;;   (setq inhibit-compacting-font-caches t)
;;   )

(package-initialize)
(elpy-enable)
(put 'downcase-region 'disabled nil)
