# 一、禁用自带的firewalld服务

CentOS7默认的防火墙不是iptables,而是firewalle

1、关闭firewall

```
#停止firewall
systemctl stop firewalld.service

#禁止firewall开机启动
systemctl disable firewalld.service
或
systemctl mask firewalld

#查看默认防火墙状态(not running:关闭，running:开启)
root># firewall-cmd --state 
not running
```

# 二、安装iptable iptable-service

```
#先检查是否安装了iptables
service iptables status
或
systemctl status iptables.service

#如果没安装，使用yum安装
yum install -y iptables
yum install -y iptables-services

#升级iptables
yum update iptables 

#重启iptables服务并设置为开机启动
systemctl restart iptables.service
systemctl enable iptables.service
```

# 三、设置规则
```
#查看iptables现有规则
iptables -L -n
#先允许所有,不然有可能会杯具
iptables -P INPUT ACCEPT
#清空所有默认规则
iptables -F
#清空所有自定义规则
iptables -X
#所有计数器归0
iptables -Z
#允许来自于lo接口的数据包(本地访问)
iptables -A INPUT -i lo -j ACCEPT
#开放22端口
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#开放21端口(FTP)
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
#开放80端口(HTTP)
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#开放443端口(HTTPS)
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#允许ping
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
#允许接受本机请求之后的返回数据 RELATED,是为FTP设置的
iptables -A INPUT -m state --state  RELATED,ESTABLISHED -j ACCEPT
#其他入站一律丢弃
iptables -P INPUT DROP
#所有出站一律绿灯
iptables -P OUTPUT ACCEPT
#所有转发一律丢弃
iptables -P FORWARD DROP
```

# 三、其他规则设定
```
#如果要添加内网ip信任（接受其所有TCP请求）
iptables -A INPUT -p tcp -s 45.96.174.68 -j ACCEPT

#过滤所有非以上规则的请求
iptables -P INPUT DROP

#要封停一个IP，使用下面这条命令：
iptables -I INPUT -s ***.***.***.*** -j DROP

#要解封一个IP，使用下面这条命令:
iptables -D INPUT -s ***.***.***.*** -j DROP
```

# 四、保存规则设定
```
#保存上述规则
service iptables save



#注册iptables服务
#相当于以前的chkconfig iptables on
systemctl enable iptables.service

#开启服务
systemctl start iptables.service

#查看状态
systemctl status iptables.service
```

# 五、防火墙完整设置脚本
```
#!/bin/sh
iptables -P INPUT ACCEPT
iptables -F
iptables -X
iptables -Z
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP
service iptables save
systemctl restart iptables.service
```

参考资料：

https://www.cnblogs.com/kreo/p/4368811.html
