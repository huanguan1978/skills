### 01-Flutter多端开发-环境配置-Fedora39

#### 启用flutter镜像站点
```sh
# 导出环境变量, ~/.bashrc
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

#### 缺失chrome
最新：针对flutter doctor检测出来的，缺失chrom和认别不了Vscode版本号，用非snap方式的*本机安装*即可完美解决。

>>> [✗] Chrome - develop for the web (Cannot find Chrome executable at google-chrome)
>>>    ! Cannot find Chrome. Try setting CHROME_EXECUTABLE to a Chrome executable.

```sh
# 安装chromium
$ sudo snap install chromium

# 导出环境变量, ~/.bashrc
CHROME_EXECUTABLE=/snap/bin/chromium
export CHROME_EXECUTABLE
```

#### 对一个现有的项目增加WEB平台支持
```sh
$ flutter create --platforms web .
```

#### Image.network，无法正常显示图片，报错error -MissingAllowOriginHeader.

1- Go to flutter\bin\cache and remove a file named: flutter_tools.stamp
2- Go to flutter\packages\flutter_tools\lib\src\web and open the file chrome.dart.
3- Find '--disable-extensions'
4- Add '--disable-web-security'

或者，在你的vscode的launch.json中加入如下args参数"--web-browser-flag=--disable-web-security"
```json
{
    "version": "0.2.0",
    "configurations": [
    {
            "name": "dfapp",
            "request": "launch",
            "type": "dart",
            "args": ["--web-browser-flag=--disable-web-security"]
        },
	}
}
```

#### 打包APK时报错，Exception in thread "main" java.net.ConnectException: Connection timed out

在项目路径文件android/gradle/wrapper/gradle-wrapper.properties中找到distributionUrl项,如:distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip，手工下载此文件并引入项目.

```ini
# gradle-wrapper.properties
# distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
distributionUrl=file:///home/kaguya/Development/gradle/gradle-7.5-all.zip
```

#### 打包APK时报错，打包工具版本号设置

在项目路径文件android/app/build.grade指定如下项值即可

```ini
# build.grade
# compileSdkVersion flutter.compileSdkVersion
compileSdkVersion 34
# minSdkVersion flutter.minSdkVersion
minSdkVersion 26
# targetSdkVersion flutter.targetSdkVersion
targetSdkVersion 34
```
