手工下载OTA安装waydroid

#### Fedora38 安装 waydroid
```shell
sudo dnf install waydroid
sudo systemctl enable --now waydroid-container
# first-luanch, initialization
# System OTA: https://ota.waydro.id/system
# Vendor OTA: https://ota.waydro.id/vendor
```

#### 手工下载OTA安装Image
```shell
cd ~/Downloads

# https://github.com/waydroid/OTA/blob/master/system/lineage/waydroid_x86_64/VANILLA.json
wget https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_x86_64/lineage-18.1-20230819-VANILLA-waydroid_x86_64-system.zip/download

# https://github.com/waydroid/OTA/blob/master/vendor/waydroid_x86_64/MAINLINE.json
wget https://sourceforge.net/projects/waydroid/files/images/vendor/waydroid_x86_64/lineage-18.1-20230819-MAINLINE-waydroid_x86_64-vendor.zip/download

# 解压ZIP包中的system.img,vendor.img到此目录/usr/share/waydroid-extra/images/
# 终端命令行系统初始化
sudo waydroid init -f -c https://ota.waydro.id/system -v https://ota.waydro.id/vendor

# 终端命令行系统初始化且启动
waydroid first-launch
```

#### 安装应用
```shell
cd ~/Downloads
waydroid app install F-Droid.apk
```
#### 启用代理
```shell
# 系统代理环境变量设置
export no_proxy=localhost,127.0.0.0/8,::1
export http_proxy=http://127.0.0.1:7890/
export https_proxy=https://127.0.0.1:7890/
export all_proxy=socks://127.0.0.1:7891/

# adb shell 设置proxy
sudo waydroid shell settings put global http_proxy "192.168.100.200:7890"
sudo waydroid shell settings put global https_proxy "192.168.100.200:7890"


# 重启当前会话
waydroid session stop
waydroid session start
```

#### 不在Gnome显示Waydroid应用图标, waydroid.*.desktop中添加NoDisplay=true
```ini
# ~/.local/share/applications/waydroid.*.desktop中添加NoDisplay=true
[Desktop Entry]
Type=Application
Name=Clock
Exec=waydroid app launch com.android.deskclock
Icon=/home/kaguya/.local/share/waydroid/data/icons/com.android.deskclock.png
NoDisplay=true
Categories=X-WayDroid-App;
X-Purism-FormFactor=Workstation;Mobile;
Actions=app_settings;
[Desktop Action app_settings]
Name=App Settings
Exec=waydroid app intent android.settings.APPLICATION_DETAILS_SETTINGS package:com.android.deskclock
```
#### 修复安卓应用竖屏问题
```shell
sudo waydroid shell wm set-fix-to-user-rotation enabled
```
#### waydroid启动时开启竖屏
```shell
# vi /var/lib/waydroid/waydroid.cfg
waydroid prop set persist.waydroid.width 1280
waydroid prop set persist.waydroid.height 720
```

#### waydroid系统DPI设置,进入开发者模式,
- MDPI (Medium Dots per Inch):    Resolution: 160 DPI (Dots per Inch)    Image resolution: 1x baseline (mdpi)    Example image size: 48x48 pixels
- HDPI (High Dots per Inch):    Resolution: 240 DPI (Dots per Inch)    Image resolution: 1.5x baseline (hdpi)    Example image size: 72x72 pixels
- XHDPI (Extra High Dots per Inch):    Resolution: 320 DPI (Dots per Inch)    Image resolution: 2x baseline (xhdpi)    Example image size: 96x96 pixels
- XXHDPI (Extra Extra High Dots per Inch):    Resolution: 480 DPI (Dots per Inch)    Image resolution: 3x baseline (xxhdpi)    Example image size: 144x144 pixels
1. Setting->About phone->Build number(dblclick)
2. Setting->System->Advanced->Developer Options->DRAWING(SmallestWidth:480)


#### Uiautomator2 连接 Waydroid
```python
import uiautomator2 as u2

# 192.168.240.112 是你的安卓联网后的IP地址
d = u2.connect_adb_wifi('192.168.240.112')
print(d.info)

# d.info 返回如下数据
# {'currentPackageName': 'cu.axel.smartdock', 'displayHeight': 736, 'displayRotation': 0, 
#'displaySizeDpX': 1214, 'displaySizeDpY': 654, 'displayWidth': 1366, 
# 'productName': 'lineage_waydroid_x86_64', 'screenOn': True, 'sdkInt': 30, 'naturalOrientation': True}
```
