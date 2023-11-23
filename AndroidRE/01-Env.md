01-安卓逆向工程手记-环境配置

## apktool 常用功能

### apktool二次封包
```shell
# 解包apk到指定目录, 如解包app-release-1.apk到 app目录下
$ java -jar apktool.jar d app-release-1.apk -o app
$ java -jar e:\AndroidRE\apktool_2.9.0.jar d app-release-1.apk -o app

# 重新打包目录为apk, 如打包app目录为 app-debug-1.apk
$ java -jar apktool.jar b app -o app-debug-1.apk
$ java -jar e:\AndroidRE\apktool_2.9.0.jar b app -o app-debug-1.apk
```

### zipalign包对齐
```shell
# 若包内有二进制so档时，一定要加-p参数
$ zipalign.exe -p -f -v 4 app-debug-1.apk app-zadbg-1.apk
```

### apksigner包重新签名
```shell
# V2级以上签名，需先zipalign包对齐后再签
$ apksigner.bat sign --ks tst.keystore --ks-key-alias tst.keystore --out app-redbg-1.apk app-zadbg-1.apk
$ apksigner.bat sign --ks tstscanprint.keystore --ks-key-alias tstscanprint.keystore --out app-redbg-1.apk app-zadbg-1.apk
```


### apktool 改包名（改包名可多开）
```text
# AndroidManifest.xml, 原manifest节点属性package="com.zj.wuaipojie"改如下
package="com.zj.wuaipojie_re"

# AndroidManifest.xml,在<application></application>内新增节点如下
<meta-data android:name="CHANNEL" android:value="TapTap"/>

# AndroidManifest.xml,若provider节点有android:authorities属性时需一并更改
# AndroidManifest.xml,若需开启应用调试，请在原application节点新增属性 android:debuggable="true"

# apktool.yml, 填上新包名，如下
renameManifestPackage: com.zj.wuaipojie_re

# res\values\strings.xml, 更改应用显示名，string节点属性为name="app_name"的节点值即是应用显示名，如下
<string name="app_name">吾爱破解</string>

# AndroidManifest.xml, 查找应用图标名，application节点中属性android:icon， 如android:icon="@mipmap/ic_launcher"
# res\mipmap-*dpi，替换不同尺寸的ic_laucher图标，推荐用在线工具http://androidasset.studio/一键生成各种规格的安卓应用图标

```

## 静态逆向包常见操用

### 改文本内容（如：汉化文本，校正文本）
```text
# 界面上的静态文本，大多在res\layout\*.xml, 常见于节点属性android:text， 请用目录搜索res，
# 若遇到非已母语系统文本，需借助页面资分析，如第三方工具（开发者助手）
```
