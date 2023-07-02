Mitmproxy手记

#### upstream proxy
```shell
mitmproxy --mode=upstream:http://127.0.0.1:7890 -s ~/Projects/myscript.py
mitmproxy --mode=upstream:http://127.0.0.1:7890 --upstream-auth=username:pwd -s ~/Projects/myscript.py
```
#### reverse proxy
```shell
# 你有一个本机服务A端口8000,你想把访问80端口的B服务都转到A,可用反向代理解决
# 设想80端口的B服务,是公开对外服务,而隐身在B服务后的A服务,或A类服务群下的A1,A2,A3服务对都可以通过返向代理来灵活调配
# 注意事项1,响应文档中的绝对URL和重定向不会被ReverseProxy处理,解决方案是在/etc/hosts中把所有ListenHost都指向到ReverseHost
# 注意事项2,反向代理模式下mitmproxy会自动重写Host标头以匹配上游服务器,可用keep_host_header选项禁用此行为

# 例1.把80端口的访问转给tp6处理(tp6运行端口为8000)
mitmproxy --mode reverse:http://127.0.0.1:8000 --listen-host 127.0.0.1 --listen-port 80
# 例2.把80端口的访问转给flask处理(flask运行端口为5000)
mitmproxy --mode reverse:http://127.0.0.1:5000 --listen-host 127.0.0.1 --listen-port 80

```

#### android证书安装
```
# android4证书安装后的mitmproxy配置, Option connection_strategy=lazy, tls_version_client_min=TLS1
```
#### fedora38证书安装
```shell
# 从http://mitm.it下载linux证书,如证书名为 mitmproxy-ca-cert-linux.pem
sudo mv mitmproxy-ca-cert-linux.pem /etc/pki/ca-trust/source/
sudo update-ca-trust

# playwright chromium 安装mitmproxy证书, chromium证书数据在 ~/.pki/nssdb,留意这个上上录chromiue要读写权
sudo dnf install nss-tools

# 查看已有证书
certutil -d ~/.pki/nssdb -L
# 安装mitmproxy的linux证书, -n参数为你安装后的证书名,-i参数为要安装的证书文件
certutil -d ~/.pki/nssdb -A -t "C,," -n fedroa38mitmproxy -i /etc/pki/ca-trust/source/mitmproxy-ca-cert-linux.pem

```

#### Transparent Gateway Proxy
```shell
# 透明代理之透明网关,需在终端机网络设置网关为代理机IP地址,终端机应用则无需变动(如一些无法自配置代理访问的应用)
```

#### clash proxy
```shell
# UI https://clash.razord.top
# local config.yaml
cd ~/Downloads/clash-linux-amd64-v1.16.0
./clash-linux-amd64 -d .
```
