```
1、升级系统补丁，注意顺序不可颠倒，也不可省略update

#更新整个仓库的版本信息

sudo apt update -y

#升级软件包
sudo apt upgrade -y

#自动清理旧版本的安装包

sudo apt autoclean -y

#删除包缓存中的所有包,多数情况下这些包没有用了,网络条件好的话，可以使用。

sudo apt clean -y


2、安装和配置SSH，防火墙配置

#安装install openssh-server
sudo apt install openssh-server -y

#允许root用户登录
sudo sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config

#刚才修改配置了，重启一下服务
sudo systemctl restart sshd

#防火墙允许ssh协议通过，不然远程没法连接SSH服务，当然你也不想直接关闭防火墙吧！用这个就安全点。
sudo ufw allow ssh

#启动防火墙

sudo ufw enable
```

# 二、修改主机名

```
https://www.cnblogs.com/zeusmyth/p/6231350.html

vim /etc/hostname
```


# 三、脚本
```
sudo apt update -y
sudo apt upgrade -y
sudo apt install openssh-server ssh -y
sudo ufw allow ssh
sudo ufw enable
sudo ufw status
cat > /etc/hostname << EOF
hk-ubuntu-188
EOF
hostname hk-ubuntu-188


useradd www -m

```

参考文档：

https://blog.csdn.net/longhr/article/details/51669449
