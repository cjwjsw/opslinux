# 一、iptables没有生效的问题

由于配置问题配置REJECT的情况

1、-A INPUT -j REJECT --reject-with icmp-host-prohibited，这行已拒绝其他端口的命令，如果我们将新插入的开放端口在放在这行命令之后的情况下，后面的配置开放的端口是不会被启用的。例如：

```
-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited --需要将这行放到-A INPUT -j REJECT规则前面才生效
-A INPUT -m state --state NEW -m tcp -p tcp --dport 3306 -j ACCEPT   --需要将这行放到-A INPUT -j REJECT规则前面才生效
```


参考文档：

https://www.jianshu.com/p/8ded7c5fda1d   CentOS 防火墙配置与REJECT导致没有生效问题
