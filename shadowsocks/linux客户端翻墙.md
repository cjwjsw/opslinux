## 前言
(需要一个已经能翻墙的 shadowsocks 服务端)

本文介绍的是在 CentOS 上安装 shadowsocks 客户端的过程，最终实现的也就是当前 CentOS 通过其他服务器的 Shadowsocks 服务联网，非在 CentOS 上安装 shadowsocks 服务端的过程，因此你需要一个已经能翻墙的 shadowsocks 服务端。

## 安装 pip
```
yum install python-pip
pip install shadowsocks
```
## 配置 shadowsocks
```
vim /etc/shadowsocks.json
```
```
{
    "server":"13.229.223.57",      #ss服务器IP
    "server_port":8388, #端口
    "local_address": "127.0.0.1",   #本地ip
    "local_port":1080,              #本地端口
    "password":"your_server_passwd",#连接ss密码
    "timeout":300,                  #等待超时
    "method":"aes-256-cfb",             #加密方式
    "fast_open": false,             # true 或 false。如果你的服务器 Linux 内核在3.7+，可以开启 fast_open 以降低延迟。开启方法： echo 3 > /proc/sys/net/ipv4/tcp_fastopen 开启之后，将 fast_open 的配置设置为 true 即可
    "workers": 3                    # 工作线程数
}
```
