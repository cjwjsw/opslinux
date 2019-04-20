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
echo 511 > /proc/sys/net/core/somaxconn

vim /etc/sysctl.conf
然后sysctl -p 使配置文件生效
vm.overcommit_memory=1
或
sysctl vm.overcommit_memory=1
或
echo 1 > /proc/sys/vm/overcommit_memory

vim /etc/rc.local
新增
echo never > /sys/kernel/mm/transparent_hugepage/enabled。
```


# 防火墙配置
```
iptables -A INPUT -s x.x.x.x -p tcp --dport 6379 -j ACCEPT
```

参考文档：

https://segmentfault.com/a/1190000017780463  Centos7安装Redis 


http://www.144d.com/post-583.html

