# 一、查看当前防火墙状态
 由于LInux原始的防火墙工具iptables过于繁琐，所以ubuntu默认提供了一个基于iptable之上的防火墙工具ufw。
```
安装
sudo apt-get install -y ufw
 
查看当前防火墙状态
sudo ufw status

inactive状态是防火墙关闭状态 
active是开启状态。
```

# 二、开启防火墙
```
开启防火墙 
sudo ufw enable

查看开启防火墙后的状态
sudo ufw status

active 说明防火墙开启成功。
```

# 三、关闭防火墙
```
sudo ufw disable

sudo ufw status
如果是inactive 说明我们的防火墙已经关闭掉
```

# 四、常用指令
```
UFW 使用范例：

允许 53 端口

$ sudo ufw allow 53

禁用 53 端口

$ sudo ufw delete allow 53

允许 80 端口

$ sudo ufw allow 80/tcp

禁用 80 端口

$ sudo ufw delete allow 80/tcp

允许 smtp 端口

$ sudo ufw allow smtp

删除 smtp 端口的许可

$ sudo ufw delete allow smtp

允许某特定 IP

$ sudo ufw allow from 192.168.254.254

删除上面的规则

$ sudo ufw delete allow from 192.168.254.254

```

# 五、脚本
```
sudo apt-get install -y ufw
sudo ufw allow 22
sudo ufw allow 33389
sudo ufw allow from 192.168.52.0/24
sudo ufw default deny  #默认关闭所有外部访问
sudo ufw enable
sudo ufw status
```
