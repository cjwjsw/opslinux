# 一、安装

```
#1、安装依赖
yum -y install gcc gcc-c++ kernel-devel

#2、下载，解压，编译安装
cd /usr/local/src/
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
mkdir -p /data0/redis_data
chown -R redis:redis /data0/redis_data
chown -R redis:redis /var/log/redis_6379.log

tail -100f /var/log/redis_6379.log
```

# 二、配置

1、哨兵一配置
```

mkdir -p /data0/redis_data/sentinel_16379
chown -R redis:redis /data0/redis_data/

port 16379
daemonize yes
protected-mode no
dir "/data0/redis_data/sentinel_16379"
logfile "/var/log/redis_16379.log"
sentinel monitor mymaster 172.31.234.36 6379 1
sentinel down-after-milliseconds mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel auth-pass mymaster Allwell!#@2019 
sentinel failover-timeout mymaster 15000
```

2、哨兵二配置
```
mkdir -p /data0/redis_data/sentinel_16379
chown -R redis:redis /data0/redis_data/

port 16379
daemonize yes
protected-mode no
dir "/data0/redis_data/sentinel_16379"
logfile "/var/log/redis_16379.log"
sentinel monitor mymaster 172.31.234.36 6379 1
sentinel down-after-milliseconds mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel auth-pass mymaster Allwell!#@2019 
sentinel failover-timeout mymaster 15000
```


3、哨兵二配置
```
mkdir -p /data0/redis_data/sentinel_16379
chown -R redis:redis /data0/redis_data/

port 16380
daemonize yes
protected-mode no
dir "/data0/redis_data/sentinel_16379"
logfile "/var/log/redis_16380.log"
sentinel monitor mymaster 172.31.234.36 6379 1
sentinel down-after-milliseconds mymaster 5000
sentinel parallel-syncs mymaster 1
sentinel auth-pass mymaster Allwell!#@2019 
sentinel failover-timeout mymaster 15000
```


# 三、测试

参考文档：

https://www.cnblogs.com/yjmyzz/p/redis-sentinel-sample.html   redis 学习笔记(4)-HA高可用方案Sentinel配置 
