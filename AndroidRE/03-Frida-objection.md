### 01-安卓逆向工程手记-Frida-objection

#### frida-objection安装，objection需安装旧版frida,和frida-tools,这里以新建虚拟环境v1为例

安装objection最新版最近日期的frida和frida-tools

最新版的objection 1.11.0发布于2021-04-16，且objection已说明支持frida>=15，最接近的15版本号的frida==15.2.2，最接近15版本号的frida-tools=11.0.0

frida-server也需匹配对应版本，如：模拟器对应frida-server-15.2.2-android-x86_64

```sh
$ python -m venv ~/v1
$ ~/v1/Scripts/activate

# 安装objection及配套frida-tools环境
$ pip install frida==15.2.2
$ pip install frida-tools==11.0.0
$ pip install objection==1.11.0

# 测试安装是否成功
$ objection
```

#### objection signapk 实用工具之包对齊和包签名(用objection的key)
这个实用工具整合了包对齐和包签名两步操作，前提需要apktool和android build-tools（java8sdk建议用Android SDK Build-Tools 29.3.0）

若apktool和buildtools安装在同一路径，则需设置环境变量path类似如下:
```sh
$ export PATH="$PATH:$HOME/Downloads/AndroidRE/build-tools_r29.0.3-linux/android-10"
```

#### objection RPC用法
```shell
# 启动adb端口转发
$ adb forward tcp:27034 tcp:27034

# 构件构住进程（-g）开始api服务（api）
$ objection -g asvid.github.io.fridaapp api

# API调用示例，获取APP下所有的activity
$  curl -s "http://127.0.0.1:8888/rpc/invoke/androidHookingListActivities"

# API调用示例，获取指定类下的方法清单
$ curl -s -X POST "http://127.0.0.1:8888/rpc/invoke/androidHookingGetClassMethods" -H "Content-Type: application/json" -d '{"className": "asvid.github.io.fridaapp.MainActivity"}'

# API调用示例，运行JS代码
$ curl -X POST -H "Content-Type: text/javascript" http://127.0.0.1:8888/script/runonce -d "send(Frida.version);"

# API调用示例，运行JS代码（运行远程JS文件，using the @ directory for the --data/-d flag）
$ curl -X POST -H "Content-Type: text/javascript" http://127.0.0.1:8888/script/runonce -d "@script.js"

```

#### objection 用法
外网教程 https://book.hacktricks.xyz/mobile-pentesting/android-app-pentesting/frida-tutorial/objection-tutorial

目标应用 https://github.com/asvid/FridaApp/blob/master/app-release.apk

应用包名 asvid.github.io.fridaapp

```sh
# adb shell 获得包名
$ adb shell 'pm list packages |grep bank'

# 启动adb端口转发
$ adb forward tcp:27034 tcp:27034

# Adb连接Waydroid模拟器
$ adb 192.168.240.112:5555

# 构件构住进程（-g）开始对象探索（explore）
$ objection -g asvid.github.io.fridaapp explore

# 构件构住进程（-g）开始对象探索（explore）,启动时就注入指今（--startup-command, -s ）
$ objection -g asvid.github.io.fridaapp explore  --startup-command 'android hooking watch class_method asvid.github.io.fridaapp.MainActivity.checkPin --dump-args --dump-return'

# 枚举APP相关的环境信息（目录信息）
$ env

# 获得命令帮助信息（命令之前加 help）
$ help env
$ help android hooking search classes


# 列出APP所有的activity
$ android hooking list activities

# 启动指定的activity
$ android intent launch_activity asvid.github.io.fridaapp.MainActivity

# 获得当前正运行的activity
$ android hooking get current_activity

# 列出所有classes
$ android hooking list classes 

# 筛选匹配的classes（search classes）
$ android hooking search classes asvid.github.io.fridaapp

# 列出所有指定类下的方法（list class_methods）
$ android hooking list class_methods asvid.github.io.fridaapp.Security

# 监听整个类（watch class）
$ android hooking watch class asvid.github.io.fridaapp.Security

# 监听指定方法（watch class_method），入参（--dump-args）和返回值（--dump-return）
$ android hooking watch class_method asvid.github.io.fridaapp.MainActivity.checkPin --dump-args --dump-return

# 监听指定方法，入参,返回值,堆栈信息（--dump-backtrace）
$ android hooking watch class_method asvid.github.io.fridaapp.MainActivity.checkPin --dump-args --dump-return --dump-backtrace
```

#### objection 主动调用函数
```sh
# 1.寻找该方法内存位置, 并复制找到的内存地址
$ android heap search instances asvid.github.io.fridaapp.MainActivity

# 2.监听指定方法，入参,返回值
$ android hooking watch class_method asvid.github.io.fridaapp.MainActivity.checkPin --dump-args --dump-return

# 3.0 主动调用该函数，无参调用(execute)
$ android heap execute 4041411 getString

# 3.1 主动调用该函数，带参调用(evaluate），进入编辑器code参数，编辑器退出后立即调用
# 进入编辑器code参数
$ android heap evaluate 4041411
# 编辑器code参数，按ESC和Enter键保存和执行
$ console.log(clazz.checkPin('1111'));

```

#### objection 实用功能
```sh
# 钩住真假返回值（针对返回bool类型的方法，在钩住期间总是返回你指定的值）
android hooking set return_value asvid.github.io.fridaapp.MainActivity.checkPin true
```

#### objection 注意事项
若一个类没有加载到内存中，则objection是无法操作该类的。