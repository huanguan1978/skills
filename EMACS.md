WINNT EMACS28.2手记

#### Emacs中文乱码，因Emacs默认编码与文档编码不同而出现乱码，多因Emacs下使用latin或utf8而文档是gb2312编码
```lisp
C-x <RET> r ( M-x revert-buffer-with-coding-system)
```
#### 把当前文件转为utf-8编码
```lisp
C-x C-m f utf-8-unix <RET>
```

#### 另存当前文件转为utf-8编码（会提示当前文件编码）
```lisp
C-x C-m c <RET> C-x C-w <RET>
```



## 将Emacs启动为一个SERVER，编辑~/.emacs写入如下代码
```lisp
(server-start)
```

## 新建快捷方式，启动emacsclient，快捷对像位置写入如下代码
```lisp
E:\emacs28\bin\emacsclientw.exe -c -n -a E:\emacs28\bin\runemacs.exe
```
### emacsclient 命令行参数释义
* -c tells emacs to create a new frame instead of trying to use an existing frame.
* -n means no wait - don't wait for the server to return
* -a EDITOR specifies to the emacsclientw.exe which editor to run if emacs.exe is not running. An empty string starts a new server if needed

## 左键发送到，emacsclient，按 Win+r 并在运行框输入 shell:sendto，然后把上一步中，新建的emacsclient快捷方式复制过来

## WINNT下GC优化解决卡顿问题，编辑~/.emacs写入如下代码
```lisp
(when (eq system-type 'windows-nt)
  (setq gc-cons-threshold (* 512 1024 1024))
  (setq gc-cons-percentage 0.5)
  (run-with-idle-timer 5 t #'garbage-collect)
  (setq garbage-collection-messages t)
  (setq inhibit-compacting-font-caches t)
  )
```

## 将Emacs整合进WINNT右键菜单，手工生成注册表文件EmacsExplorer.reg，写入如下内容后保存且合并至注册表
```
Windows Registry Editor Version 5.00
;; Be sure to set the correct path to Emacs on your system!
[HKEY_CURRENT_USER\Software\Classes\*\shell]


;; Open file in existing frame
[HKEY_CURRENT_USER\Software\Classes\*\shell\emacsopencurrentframe]
@="&Emacs: Edit in existing window"
"icon"="E:\\emacs28\\bin\\emacsclientw.exe"
[HKEY_CURRENT_USER\Software\Classes\*\shell\emacsopencurrentframe\command]
@="E:\\emacs28\\bin\\emacsclientw.exe -n --alternate-editor=\"E:\\emacs28\\bin\\runemacs.exe\" \"%1\""

;; Open file in new frame
[HKEY_CURRENT_USER\Software\Classes\*\shell\emacsopennewframe]
@="&Emacs: Edit in new window"
"icon"="C:\\path\\to\\emacs\\bin\\emacsclientw.exe"
[HKEY_CURRENT_USER\Software\Classes\*\shell\emacsopennewframe\command]
@="E:\\emacs28\\bin\\emacsclientw.exe -n --alternate-editor=\"E:\\emacs28\\bin\\runemacs.exe\" -c \"%1\""

;; Dired for desktop background
[HKEY_CURRENT_USER\Software\Classes\DesktopBackground\shell\emacsopensameframe]
@="&Emacs: Open in dired"
"icon"="c:\\path_to\\emacs\\bin\\emacsclientw.exe"
[HKEY_CURRENT_USER\Software\Classes\DesktopBackground\shell\emacsopensameframe\command]
@="E:\\emacs28\\bin\\emacsclientw.exe  -n --alternate-editor=\"E:\\emacs28\\bin\\runemacs.exe\" -n \"%v\""

;; Dired for directory
[HKEY_CURRENT_USER\Software\Classes\Directory\shell\emacsopensameframe]
@="&Emacs: Open in dired"
"icon"="c:\\path_to\\emacs\\bin\\emacsclientw.exe"
[HKEY_CURRENT_USER\Software\Classes\Directory\shell\emacsopensameframe\command]
xb@="E:\\emacs28\\bin\\emacsclientw.exe  -n --alternate-editor=\"E:\\emacs28\\bin\\runemacs.exe\" -n \"%V\""

;; Dired for directory background
[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\emacsopensameframe]
@="&Emacs: Open in dired"
"icon"="c:\\path_to\\emacs\\bin\\emacsclientw.exe"
[HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\emacsopensameframe\command]
@="E:\\emacs28\\bin\\emacsclientw.exe  -n --alternate-editor=\"E:\\emacs28\\bin\\runemacs.exe\" -n \"%V\""

```

## 为Emacs让路，取消WINNT的AltTab全局窗口切换键(WinTab组合键同样可切换窗口),手工生成注册表文件WinAltTabCancel.reg，写入如下内容后保存且合并至注册表
```
Windows Registry Editor Version 5.00
;;AltTab SwitchWindow Cancel

[HKEY_CURRENT_USER\Control Panel\Desktop]
"CoolSwitch"=dword:00000000

[HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced]
"AltTabSettings"=dword:00000000
```

## 常用全局配置
```
;; MULE启用UTF-8
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8-auto)

(custom-set-variables
 '(server-mode t))                ;开启server模式
 '(use-short-answers t))          ;用y-or-n-p 替代 yes-or-no-p

 '(global-display-line-numbers-mode t)  ;开启全局行号显示
 '(global-whitespace-mode t)      ;开启全局白空格模式
 '(whitespace-line-column 250))   ;白空格长行行数可视

 '(indent-tabs-mode nil)         ;tab 改为插入空格
 '(c-basic-offset 4)             ;c c++ 缩进4个空格
 '(c-default-style "linux")      ;没有这个 { } 就会瞎搞

 '(package-selected-packages
   '(yasnippet-snippets yasnippet yasnippet-classic-snippets web-mode php-mode markdown-mode))

'(php-mode-coding-style 'pear)  ;PHP代码风格
 '(php-mode-template-compatibility nil)  ;PHP模式关闭HTML模板兼容
 '(php-manual-url 'zh)                   ;PHP手册中文网址
 '(php-executable "E:\\php7433nts\\php-7.4.33-nts-Win32-vc15-x86\\php.exe")
 '(php-mode-hook '(subword-mode flymake-mode)) ;PHP模式钩子启动flymake和subword模式

'(yas-global-mode t)                      ;开启全局yas模式
 '(yas-snippet-dirs
   '("c:/Users/14714/AppData/Roaming/.emacs.d/snippets" yasnippet-classic-snippets-dir yasnippet-snippets-dir)))
(custom-set-faces
 )

;; (require 'lsp-mode)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024))
(add-hook 'dart-mode-hook 'lsp)

```
