# 一、安装 Redis

```
#1、安装依赖
yum -y install gcc gcc-c++ kernel-devel

#2、下载，解压，编译安装
wget http://download.redis.io/releases/redis-4.0.10.tar.gz
tar -xzf redis-4.0.10.tar.gz
cd redis-4.0.10

#3、如果因为上次编译失败，有残留的文件
make distclean

#4、安装
make MALLOC=libc PREFIX=/usr/local/redis install
mkdir /etc/redis/
cp redis.conf /etc/redis/6379.conf
cd /usr/local/redis/bin/
cp redis-benchmark redis-cli redis-server /usr/bin/

#创建用户
useradd redis -M -s /sbin/nologin

#创建日志文件
touch /var/log/redis_6379.log
mkdir -p /var/lib/redis/6379
chown -R redis:redis /var/log/redis_6379.log
chown -R redis:redis /var/lib/redis/6379

tail -100f /var/log/redis_6379.log
```

# 二、配置环境变量
```
vim /etc/profile
export PATH="$PATH:/usr/local/redis/bin"
# 保存退出

# 让环境变量立即生效
source /etc/profile
```

# 三、redis启动脚本
```
cat > /usr/lib/systemd/system/redis.service <<-EOF
[Unit]
Description=Redis 6379
After=syslog.target network.target
[Service]
Type=forking
PrivateTmp=yes
Restart=always
ExecStart=/usr/bin/redis-server /etc/redis/6379.conf
ExecStop=/usr/bin/redis-cli -h 127.0.0.1 -p 6379 -a foobared shutdown
User=redis
Group=redis
LimitCORE=infinity
LimitNOFILE=100000
LimitNPROC=100000
[Install]
WantedBy=multi-user.target
EOF
```

# 四、redis服务启动
```
#刷新配置
systemctl daemon-reload

systemctl start redis
systemctl restart redis
systemctl stop redis

#开机自启动
systemctl enable redis
systemctl disable redis

#查看状态
systemctl status redis

```

# 五、系统参数优化
```
注意一
echo 511 > /proc/sys/net/core/somaxconn

注意二
vim /etc/sysctl.conf
然后sysctl -p 使配置文件生效
vm.overcommit_memory=1
或
sysctl vm.overcommit_memory=1
或
echo 1 > /proc/sys/vm/overcommit_memory

注意三
vim /etc/rc.local
新增
echo never > /sys/kernel/mm/transparent_hugepage/enabled
```


# 六、防火墙配置
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

iptables -A INPUT -s 192.168.56.13 -p tcp --dport 6379 -j ACCEPT

```

# 七、测试连接
```
redis-cli -h 127.0.0.1 -a "foobared"  会弹出个警告
Warning: Using a password with '-a' option on the command line interface may not be safe.

#解决办法（2>/dev/null将标准错误去除即可）
redis-cli -h 127.0.0.1 -a "foobared" 2>/dev/null
```
参考文档：

https://segmentfault.com/a/1190000017780463  Centos7安装Redis 


http://www.144d.com/post-583.html


https://www.cnblogs.com/kreo/p/4368811.html  CentOS7安装iptables防火墙
