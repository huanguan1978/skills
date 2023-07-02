#### 信息收集主机端口
```shell
nmap --min-rate 10000 -p- -oA nullbyteports 127.0.0.1
```
#### 对开放端口TCP扫描
```shell
nmap -sT -sC -sV -O -p 80,3000,9090 -oA nullbytetcp 127.0.0.1
```
#### 对开放端口UDP扫描
```shell
nmap -sU -O -p 80,3000,9090 -oA nullbyteudp 127.0.0.1
```
#### esd 支持泛解析枚举子域名
```shell
pip install esd
esd -d baidu.com
```
##### subDomainsBrute 字典枚举更多子域名,类同esd
```shell
# https://github.com/lijiejie/subDomainsBrute
python --full subDomainsBrute.py baidu.com
```


#### dirsearch 目录扫描
	-u 指定网址，需要扫描web应用目录的地址，例如 http://www.xxx.com/
	-l 指定url字典，同时包裹多个域名
	-e 指定网站后端开发语言，也就是网站开发语言(PHP、ASP、JSP等等), 如: -e php,html,js
	-w 指定字典，不指定字典，默认使用db目录下dicc.txt；需要指定的字典，在后面加绝对路径
	-r 递归目录，例如爆破出/static/目录则继续爆破/static/下级目录，直到无法爆破出其它目录为止
	-R 递归几层
	-t 指定线程数, 如 -t 20
	-s 来指定请求间的延迟
	--max-rate 指定每秒最大请求数
	--random-agent 每一个请求随机User-Agent
	--proxy 走代理通道,如: --proxy 127.0.0.1:7890 --proxy socks5://127.0.0.1:7891
	--proxy-file 走代理池,如: --proxy-file proxyservers.txt

##### 高效扫描-排除不必要的内容
	--exclude-sizes 1B,243KB 即可排除大小为1B，243KB的网站
	--exclude-texts "403 Forbidden"排除网页中含有403 Forbidden的网页
	--exclude-status 或是 -x 来指定排除的状态码
##### 防封思路
	1.代理ip
	2.线程放低
	3.去除敏感的文件探测 （zip sql后缀啥的）只做普通文件的探测（html php后缀啥的）
	4.随机UA XFF等请求头
##### 适合命令行
```shell
python dirsearch.py -e php,html,htm,js -t 10 --random-agent --max-rate 30 --exclude-sizes 1B,243KB --proxylist proxyservers.txt -u http://localhost.localdomain
python dirsearch.py -t 20 -r -R 3--random-agent --max-rate 100 --exclude-sizes 1B,540B,551B,243B,2KB,7KB,80KB,86KB,95KB,97KB -u http://localhost.localdomain
```

##### 单个url探测
```shell
python dirsearch.py -e php -u http://yourdomain.com/
```
##### 批量url探测
```shell
# urls 一行一个域名
python dirsearch.py -e php -l urls.txt
```
##### 更换字典
```shell
python dirsearch.py -e php -w words.txt -u http://youdomain.com
```
##### 随机UserAgent递归目录
```shell
python dirsearch.py -e php -r --random-agent -u http://youdomain.com
```

##### SqlMap 输出注入内容
```shell
python sqlmap -u http://127.0.0.1:3000/users/users/*
```
