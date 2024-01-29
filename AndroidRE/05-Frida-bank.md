### 安卓逆向 dvab.apk

#### 环境搭建，BackendServer后端服务启动
```sh
# 导入mysql数据
sudo systemctl start mysqld.service
# 启动nodejs后端应用
# cd ~/Downloads/AndroidRE/Damn-Vulnerable-Bank-master/BackendServer
npm start
# API地址：http://192.168.100.196:3000
```

#### 环境搭建，开启抓包工具mitmproxy
```sh
# 若仅抓包观察（allow_host[仅抓指定主机和端口]）
mitmweb --set ssl_insecure=true --set connection_strategy=lazy --set allow_hosts=192.168.100.196:3000
# 已有自定代理脚本（-s[加载脚本],--mode=upstream[二级代理]）
mitmweb --mode=upstream:http://127.0.0.1:7890 --set ssl_insecure=true --set connection_strategy=lazy --set allow_hosts=192.168.100.196:3000  -s ~/Downloads/AndroidRE/mitmproxy-dvba.py
```

#### 环境搭建，开启模拟器网络代理
```sh
sudo waydroid shell settings put global http_proxy "192.168.100.196:8080"
sudo waydroid shell settings put global https_proxy "192.168.100.196:8080"
```

#### 环境搭建，启动frida-server
```sh
# adb shell
su
cd /data/local/tmp
./frida-server-1522 &
```

#### 环境搭建，启动frida-client
```sh
# 先端口转发
adb forward tcp:27034 tcp:27034
# 无脚本启动
frida -U -f com.app.damnvulnerablebank

# 挂脚本启动(-l)
frida -U -f com.app.damnvulnerablebank -l frida-dvba.js
# frida-objection启动，先获取App进程ID，如下4761
frida-ps -U |grep bank
objection -g 4761 explore
```

#### 列出全部activities
`sh $ android hooking list activities`
```
androidx.biometric.DeviceCredentialHandlerActivity
com.app.damnvulnerablebank.AddBeneficiary
com.app.damnvulnerablebank.ApproveBeneficiary
com.app.damnvulnerablebank.BankLogin
com.app.damnvulnerablebank.CurrencyRates
com.app.damnvulnerablebank.Dashboard
com.app.damnvulnerablebank.GetTransactions
com.app.damnvulnerablebank.MainActivity
com.app.damnvulnerablebank.Myprofile
com.app.damnvulnerablebank.PendingBeneficiary
com.app.damnvulnerablebank.RegisterBank
com.app.damnvulnerablebank.ResetPassword
com.app.damnvulnerablebank.SendMoney
com.app.damnvulnerablebank.SplashScreen
com.app.damnvulnerablebank.ViewBalance
com.app.damnvulnerablebank.ViewBeneficiary
com.app.damnvulnerablebank.ViewBeneficiaryAdmin
com.google.android.gms.common.api.GoogleApiActivity
com.google.firebase.auth.internal.FederatedSignInActivity
```
#### 查找可疑so库
`sh $ memory list modules`
```text
base.odex              0x7fd95044b000  2052096 (2.0 MiB)    /data/app/~~ktEiG_3vQoyV-v4LwXnXjA==/com.app.damnvulnerablebank-bPC2AHeh5yf...
libfrida-check.so      0x7fd8f8fd6000  8192 (8.0 KiB)       /data/app/~~ktEiG_3vQoyV-v4LwXnXjA==/com.app.damnvulnerablebank-bPC2AHeh5yf...
```

`sh $ memory list exports libfrida-check.so`
```text
Type      Name                                                      Address
--------  --------------------------------------------------------  --------------
function  Java_com_app_damnvulnerablebank_FridaCheckJNI_fridaCheck  0x7fd8f8fd6710
```
`sh $ memory list exports base.odex`
```
Type      Name            Address
--------  --------------  --------------
variable  oatdata         0x7fd95044c000
variable  oatexec         0x7fd950455000
variable  oatlastword     0x7fd95045510c
variable  oatdex          0x7fd950456000
variable  oatdexlastword  0x7fd95063de08
```

#### objection hook， 可疑点位监控 
```sh
# 反逆向之frida检测
android hooking watch class_method com.app.damnvulnerablebank.FridaCheckJNI.fridaCheck --dump-args --dump-return
# 反逆向之root检测
android hooking watch class_method a.a.a.a.a.R --dump-args --dump-return
```

#### frida script， 绕过APP的frida和root检测
```javascript

```
#### hook
$ android hooking watch class_method c.b.a.e.a --dump-args --dump-return

$ android hooking watch class_method c.b.a.e.c --dump-args --dump-return
- API输入数据被c.b.a.e.b编码
$ android hooking watch class_method c.b.a.e.b --dump-args --dump-return


### objection 主动调用函数
```shell
$ android heap search instances com.zj.wuaipojie.Demo
$ android heap search instances c.b.a.e

$ android heap execute 179494581 getPublicInt

$ android heap evaluate 179494581
$ console.log(clazz.a('_helloworld_'))
