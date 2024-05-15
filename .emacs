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
 '(c-basic-offset 4)
 '(c-default-style "linux")
 '(c-indent-level 4)
 '(c-mode-common-hook
   '(lambda nil
	  (when
		  (derived-mode-p 'c-mode 'c++-mode 'java-mode))))
 '(c-set-style "linux")
 '(c-tab-always-indent t)
 '(custom-enabled-themes '(wombat))
 '(global-company-mode t)
 '(global-display-line-numbers-mode t)
 '(indent-tabs-mode t)
 '(markdown-command "/usr/bin/pandoc")
 '(package-selected-packages
   '(php-mode pyvenv dart-mode company magit markdown-mode yasnippet use-package))
 '(php-executable "/usr/bin/php")
 '(php-imenu-generic-expression 'php-imenu-generic-expression-simple)
 '(php-manual-url 'zh)
 '(php-mode-coding-style 'psr2)
 '(php-mode-hook '(subword-mode flymake-mode) t)
 '(php-mode-template-compatibility nil)
 '(tab-width 4)
 '(use-short-answers t)
 '(warning-suppress-types '((comp)))
 '(whitespace-line-column 250))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(use-package pyvenv
  :ensure t
  :init
  (setenv "WORKON_HOME" "~/v/"))

(pyvenv-activate "~/v/")
;; (setq python-shell-virtualenv-root "~/v/")
(setq eldoc-echo-area-use-multiline-p nil)
;; dart-mode
;;(add-to-list 'eglot-server-programs '(dart-mode . ("dart_language_server")))
(add-hook 'dart-mode-hook 'eglot-ensure)
(add-hook 'python-mode-hook 'eglot-ensure)

(add-hook 'php-mode-hook 'eglot-ensure)
;; (when (file-exists-p "~/Projects/iche2/enterprise/vendor/bin/psalm-language-server")
;;   (progn
;;     (require 'php-mode)
;;     (require 'eglot)
;;     (add-to-list 'eglot-server-programs '(php-mode . ("php" "/home/kaguya/Projects/iche2/enterprise/vendor/bin/psalm-language-server")))
;;     (add-hook 'php-mode-hook 'eglot-ensure)
;;     (advice-add 'eglot-eldoc-function :around
;;                 (lambda (oldfun)
;;                   (let ((help (help-at-pt-kbd-string)))
;;                     (if help (message "%s" help) (funcall oldfun)))))
;;     )
;;   )

;; (reformatter-define dart-format
;;   :program "dart"
;;   :args '("format"))
;; (reformatter-define dart-format
;;   :program "dart"
;;   :args '("format"))

(with-eval-after-load "dart-mode"
  (define-key dart-mode-map (kbd "C-c C-o") 'dart-format-buffer))


;; (require 'lsp-mode)
;; (setq gc-cons-threshold (* 100 1024 1024)
;;       read-process-output-max (* 1024 1024))
;; (add-hook 'dart-mode-hook 'lsp)

;; (setq lsp-jedi-workspace-extra-paths
;;   (vconcat lsp-jedi-workspace-extra-paths
;;            ["/home/kaguya/v/lib/python3.12/site-packages"]))
;; (add-hook 'python-mode-hook 'lsp)

;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)
