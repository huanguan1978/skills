UniServer Zero XV 15无需安装解压就能用的WAMP最好开发环境

## 15.x下载地址
```
https://sourceforge.net/projects/miniserver/files/Uniform%20Server%20ZeroXV/15_0_1_ZeroXV/15_0_1_ZeroXV.exe/download
```

## 安装新组件php7.4.33，15.0.1版自带组件mysql8.0.31,php8.2.0,apache2.4.54,phpmyadmin5.2.0，
```html
<!-- php7.4.3 下载地址 -->
https://sourceforge.net/projects/miniserver/files/Uniform%20Server%20ZeroXV/ZeroXV%20Modules/ZeroXV_php_7_4_33.exe/download

<!-- 直压解到 UniServerZ 目录下，即安装完成 -->
```

## 更换Mysql8的datadir目录
>> my.ini的mysqld段变更如下
```ini
# 原目录为D:/zeroxv/UniServerZ/core/mysql/data，新目录为D:/zeroxv/localdb/data
# datadir change, 

lc-messages-dir= D:/zeroxv/UniServerZ/core/mysql/share
lc-messages="en_US"
log_timestamps=SYSTEM

basedir = D:/zeroxv/UniServerZ/core/mysql/data
datadir = D:/zeroxv/localdb/data
log-error = D:/zeroxv/localdb/data/mysql.err

sql-mode="STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
default-time-zone='+08:00'
```
>> us_config.ini新增MYSQL段如下
```ini
# UniServerZ/home/us_config/us_config.ini

[MYSQL]
defaults-file=D:/zeroxv/UniServerZ/core/mysql/my.ini
tmpdir=D:/zeroxv/UniServerZ/tmp
datadir=D:/zeroxv/localdb/data
innodb_data_home_dir=D:/zeroxv/localdb/data
innodb_log_group_home_dir=D:/zeroxv/localdb/data
```


## 新建本地开发虚拟主机
```ini
# UniServerZ/core/apache2/conf/extra/httpd-vhosts.conf

<VirtualHost *:${AP_PORT}>
 ServerAdmin webmaster@iche2.localhost.localdomain
 DocumentRoot D:/zeroxv/localweb/iche2
 ServerName iche2.localhost.localdomain
 ServerAlias iche2.localhost.localdomain
 ErrorLog D:/zeroxv/localweb/iche2/logs/iche2.localhost.localdomain-error.log
 CustomLog D:/zeroxv/localweb/iche2/logs/iche2.localhost.localdomain-access.log common
 <Directory "D:/zeroxv/localweb/iche2/">
   Options Indexes Includes
   AllowOverride All
   Require all granted
 </Directory>
</VirtualHost>
```

## WAMP管理面板，启动、停止、重启操作 UniServerZ\UniController.exe
![UniController](https://www.uniformserver.com/assets/images/logo/unicontroller.png "UniController Screenshots")
