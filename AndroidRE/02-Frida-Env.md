01-安卓逆向工程手记-环境配置-Frida

### frida-server配置
1.请先用pip list查询本机安装的frida版本号，如本机frida版本号为16.1.6
2.从https://github.com/frida/frida/releases 下载server端安装包，这里需注意你所用的设备CPU架构，如本机为x86_64位的安卓模拟器，下载安装包为 frida-server-16.1.6-android-x86_64.xz
3.解压缩xz文件后,用adb推送安装包到安卓系统
```shell
$ ldconsole.exe push --index 0 --remote /mnt/shared/Pictures/temp/ --local e:\AndroidRE\frida-server-16.1.6-android-x86_64\frida-server-16.1.6-android-x86_64

# 找到目标文件用adb push推送移动端
$ cd e:\AndroidRE\frida-server-16.1.6-android-x86_64\
$ e:
$ adb push .\frida-server-16.1.6-android-x86_64 /data/local/tmp/frida-srv-1616

# 连接shell从移动端启动frida-server
$ adb shell
$ su
$ cd /data/local/tmp/
$ chmod 755 frida-srv-1616
$ ./frida-srv-1616
```

### frida-cliect配置
```shell
# 在开发机启动adb端口转发
$ adb forward tcp:27042 tcp:27042
# 测试frida是否连通
$ frida-ps -R
```


### frida-cliect启动自定义脚本
```shell
# -U:连接USB设备，-F:附加最前面的应用，-f:主动启动进程，-l：加载script脚本，-o:输出日志，--no-pause:启动主线程运行应用
$ frida -U -f com.zj.wuaipojie -l hook_udef_encode.js -o logs_udef_encode.txt --no-pause
```

### Probable cause that remount fails is you are not running adb as root
```shell
# List the Devices.
adb devices;

# Run adb as root
adb root

adb remount;
adb shell su -c "mount -o rw,remount /";

# migisk 报错异常状态，检测到不属于Magisk的su文件，请删除其他超级用户程序
adb shell su -c "mv /system/xbin/su /system/xbin/su.bak"
```
### Win10终端显示UTF8字符
```shell
# 切换终端字符集编码为UTF8
chcp 65001
# 切换终端字符集编码为GBK
chcp 936
# 终端logcat过滤日志, adb shell过入后，shell命令如下：
$logcat | grep "D zj2595"
```
