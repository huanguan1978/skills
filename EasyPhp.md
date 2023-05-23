EasyPHP Devserve 17手记

## Devserver17.x下载地址
```
https://www.easyphp.org/easyphp-devserver.php
```

## 17.x可升级模块和组件,可升级版本 MYSQL8.0.20, PHP7.4.27, PHP8.1.2, APACHE2.4.48
```
https://warehouse.easyphp.org/inventory-devserver
```

## 17.x默认安装包内的32位组件升级64位组件，示例如下(安装目录为D:/EasyPhpDevS17/)：
- 32位的x86版APACEH2.4.25,升级至x64位的APACEH2.4.48,编辑conf_httpserver.php内容如下:
```php
<?php
// D:/EasyPhpDevS17/eds-dashboard/conf_httpserver.php

$conf_httpserver = array(
	"httpserver_folder" => "apache2448vc15x64x230515084006", // 你的64位Apache路径
	"httpserver_port" => "80",
	"php_folder" => "php7427vc15x64x230515074712",          // 你的64位PHP路径
);
?>
```

- 32位的x86版PHP5.6和PHP7.1,升级至x64位的PHP7.4,参考APACE升级部份(注:64位的APACE才能启用64位的PHP)
- 32位的x86版MYSQL5.7.17,升级至x64位的MYSQL8.0.20,编辑conf_dbserver.php内容如下:
```php
<?php
// D:/EasyPhpDevS17/eds-dashboard/conf_dbserver.php.php

$conf_dbserver = array(
	"dbserver_folder" => "mysql8020x64x230515085515", // 你的64位MYSQL路径
	"dbserver_port" => "3306",
);
?>
```

## 17.x安装或升级时常见问题
- msvcr110.dll丢失,安装VC11版的32位和64位vc_redist，下载地址如下:
```html
<!-- -->
https://www.microsoft.com/en-us/download/details.aspx?id=30679
```

- 无法加载PHP_CURL库，需要apache.conf中用LoadFile加载libssh2.dll，如下:
```ini
# PHP Warning:  PHP Startup: Unable to load dynamic library 'curl'
# D:/EasyPhpDevS17/eds-binaries/httpserver/apache2448vc15x64x230515084006/conf/httpd.conf

LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/libssh2.dll"
```

- 无法加截sqlite3,pq,enchant,intl,xdebug等需要apache.conf中用LoadFile加载如下:
```ini
# D:/EasyPhpDevS17/eds-binaries/httpserver/apache2448vc15x64x230515084006/conf/httpd.conf

LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/libsqlite3.dll"
LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/libpq.dll"
LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/libenchant.dll"

LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/icudt66.dll"
LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/icuin66.dll"
LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/icuio66.dll"
LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/icuuc66.dll"

LoadFile "D:/EasyPhpDevS17/eds-binaries/php/php7427vc15x64x230515074712/php_xdebug-3.1.0-7.4-vc15-x86_64.dll"
```

- 升级至MYSQL8.0.20更换datadir后无法正常连接

-- 在Dashboard界面操作中每次启动都会还原my.ini文件，在dbserver/mysql8020x64/eds-app-actions.php中注解如下代码
```php
// d:/EasyPhpDevS17/eds-binaries/dbserver/mysql8020x64x230515085515/eds-app-actions.php

// file_put_contents (__DIR__ . '\my.ini', $serverconffile); // 禁止重写my.ini
```

-- mysql时间相差8个小时，在my.ini中加入default-time-zone='+08:00'配置后重启
```ini
[mysqld]
default-time-zone='+08:00'
```


-- mysql_error.log报错[ERROR] [MY-010131] [Server] TCP/IP, --shared-memory, or --named-pipe should be configured on NT OS，在my.ini中加入shared-memory配置后重启
```ini
[mysqld]
shared-memory
```

-- mysql命今行报错ERROR 1045 (28000): Access denied for user 'ODBC'@'localhost'，在my.ini中加入skip_grant_tables配置后重启且重置密码
```ini
[mysqld]
skip_grant_tables
```

-- 重置mysql8的用户密码(重置密码后需去除my.ini中的shared-memory,skip_grant_tables配置后重启mysqld)，在mydql命令行如下顺序执行
```sql
use mysql;
flush privileges;
alter user 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '12345678!@#$';
flush privileges;
```

-- mysql_error.log报错[ERROR] [MY-012271] [InnoDB] The innodb_system data file 'ibdata1' must be writable，停止mysqld服务删除datadir目录下的ib_logfile0,ib_logfile1

-- mysql_error.log报错[ERROR] [MY-011971] [InnoDB] Tablespace 'innodb_undo_001' Page，停止mysqld服务删除datadir目录下的undo_001,undo_002


## 17.x phpmysqladmin配置
- msvcr110.dll丢失,安装VC11版的32位和64位vc_redist，下载地址如下:
