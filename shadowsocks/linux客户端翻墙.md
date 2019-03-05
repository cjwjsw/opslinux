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
    "server":"13.229.223.57",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"your_server_passwd",
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open": false,
    "workers": 3
}
```
## 启动shadowsocks服务
```
sslocal -c /etc/shadowsocks.json
```
## 设置shadowsocks开机自启
```
配置开机自启
sudo vim /etc/systemd/system/shadowsocks.service

[Unit]
Description=Shadowsocks Client Service
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks.json

[Install]
WantedBy=multi-user.target

配置生效
systemctl enable /etc/systemd/system/shadowsocks.service
```
## 测试验证
```
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip

如果返回你的 ss 服务器 ip 则测试成功：
{
  "origin": "13.229.223.57, 13.229.223.57"
}

```
