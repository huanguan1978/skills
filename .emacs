;; (server-start)
;; (setq default-tab-width 4)

;;(set-language-environment 'utf-8)
;;(prefer-coding-system 'utf-8-auto)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-display-line-numbers-mode t)
 '(global-whitespace-mode t)
 '(package-selected-packages
   '(magit yasnippet-snippets yasnippet yasnippet-classic-snippets web-mode php-mode markdown-mode))
 '(php-mode-hook '(subword-mode flymake-mode))
 '(selection-coding-system 'utf-8)
 '(server-mode t)
 '(use-short-answers t)
 '(whitespace-line-column 250)
 '(yas-global-mode t)
 '(yas-snippet-dirs
   '("c:/Users/14714/AppData/Roaming/.emacs.d/snippets" yasnippet-classic-snippets-dir yasnippet-snippets-dir)))
 '(indent-tabs-mode nil)
 '(c-basic-offset 4)
 '(c-default-style "linux")
 '(php-executable "E:\\php7433nts\\php-7.4.33-nts-Win32-vc15-x86\\php.exe")
 '(php-manual-url 'zh)
 '(php-mode-coding-style 'pear)
 '(php-mode-template-compatibility nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(when (eq system-type 'windows-nt)
  (setq gc-cons-threshold (* 512 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 10 t #'garbage-collect)
  (setq garbage-collection-messages t)
  (setq inhibit-compacting-font-caches t)
  )
