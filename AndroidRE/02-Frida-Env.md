### 01-安卓逆向工程手记-环境配置-Frida

#### frida-server配置
1. 请先用pip list查询本机安装的frida版本号，如本机frida版本号为16.1.6

2. 从https://github.com/frida/frida/releases 下载server端安装包，这里需注意你所用的设备CPU架构，如本机为x86_64位的安卓模拟器，下载安装包为 frida-server-16.1.6-android-x86_64.xz

3. 解压缩xz文件后,用adb推送安装包到安卓系统

```sh
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

#### frida-cliect配置
```sh
# 在开发机启动adb端口转发
$ adb forward tcp:27042 tcp:27042
# 测试frida是否连通
$ frida-ps -R
```


#### frida-cliect启动自定义脚本
```sh
# -U:连接USB设备，-F:附加最前面的应用，-f:主动启动进程，-l：加载script脚本，-o:输出日志，--no-pause:启动主线程运行应用
$ frida -U -f asvid.github.io.fridaapp -l myhook.js -o myhook.log --no-pause
```

#### Probable cause that remount fails is you are not running adb as root
```sh
# List the Devices.
adb devices;

# Run adb as root
adb root

adb remount;
adb shell su -c "mount -o rw,remount /";

# migisk 报错异常状态，检测到不属于Magisk的su文件，请删除其他超级用户程序
adb shell su -c "mv /system/xbin/su /system/xbin/su.bak"
```

#### Win10终端显示UTF8字符
```cmd
# 切换终端字符集编码为UTF8
chcp 65001
# 切换终端字符集编码为GBK
chcp 936
# 终端logcat过滤日志, adb shell过入后，shell命令如下：
$logcat | grep "D zj2595"
```

#### 安卓日志信息输出
```sh
# 查看运行中的应用进程pid
$ ps -A | grep fridaapp
# logcat 指定pid的所有日志信息
$ logcat --pid=1234
```



#### Frida加载JS脚本示例
```javascript
// myhook.js

function now(){
    return (new Date()).toLocaleString();
}

// 被动调用，监听函数调用，此示例监听入参和返回值，并修改返回值
function _skip_checkPin(){
    let _ma = Java.use('asvid.github.io.fridaapp.MainActivity');
    _ma.checkPin.implementation = function(a){
	console.log(now(), '_ma.checkPin param:', a);
	let ret = this.checkPin(a); // 原方法调用
	let ret_new = true;
	console.log(now(), '_ma.checkPin result:', ret);
	console.log(now(), '_ma.checkPin result new:', ret_new);
	return ret_new;
    };
}

function _ns_SomeClass(){
    return 'asvid.github.io.fridaapp.SomeClass';
}

// 主动调用, 创建新实例
function _tst_SomeClass(){
    let _ns = _ns_SomeClass();
    let _sc = Java.use(_ns);

    // 钩住重载函数，无参重载
    _sc.getSomeString.overload().implementation = function(){
	console.log(now(), '_sc.getSomeString run:');
	let ret = this.getSomeString(); // 原方法调用
	console.log(now(), '_sc.getSomeString result:', ret);
	return ret;
    };
    _sc.getSomeString.overload('java.lang.String').implementation = function(a){
	console.log(now(), '_sc.getSomeString param:', a);
	let ret = this.getSomeString(a); // 原方法调用
	console.log(now(), '_sc.getSomeString result:', ret);
	return ret;
    };

    _sc.getPublicField.overload().implementation = function(){
	console.log(now(), '_sc.getPublicField run');
	let ret = this.getPublicField(); // 原方法调用
	let privateField = this.privateField.value;

	this.publicField.value = 'public field 123';
	let publicField = this.publicField.value;
	console.log(now(), '_sc.privateField:', privateField);
	console.log(now(), '_sc.publicField:', publicField);
	console.log(now(), '_sc.getPublicField result:', ret);
	return ret;
    };

    var runonce = 0; // 限定仅运行一次
    Java.choose(_ns, {
	onMatch:function(obj){
	    runonce+=1;
	    if(runonce==1){
		console.log(now(), _ns, 'onMatch obj.privateField.value:', obj.privateField.value);
	    }
	},
	onComplete:function(){
	    console.log(now(), _ns, 'onComplete');
	}
    });

    var _sc_inst = _sc.$new();
    // 赋值实例成员, （非静态成员，非PUBLIC成员，不可直接实例访问）
    // _sc_inst.PublicField.value = "PublicFD1"
    // 获值实例成员，方法1直接访问成员名实，（非静态成员，非PUBLIC成员，不可直接实例访问）
    // console.log('_sc_inst.PublicField.value', _sc_inst.PublicField.value);
    // 获值实例成员，方法1通过方法封装调用
    console.log('_sc_inst.getPublicField result:', _sc_inst.getPublicField() );

    // 主调重载函数
    _sc_inst.getSomeString();
    _sc_inst.getSomeString('abc, ');
}

function test1(){
    Java.perform(function(){
	_skip_checkPin();
	_tst_SomeClass();
	console.log('--startup-script:...');
    });
};

// ----
test1();

``` 