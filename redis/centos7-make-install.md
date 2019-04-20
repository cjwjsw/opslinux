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
make PREFIX=/usr/local/redis install
mkdir /usr/local/redis/etc/
cp redis.conf /usr/local/redis/etc/
cd /usr/local/redis/bin/
cp redis-benchmark redis-cli redis-server /usr/bin/

```

# 二、配置环境变量
```
vim /etc/profile
export PATH="$PATH:/usr/local/redis/bin"
# 保存退出

# 让环境变量立即生效
source /etc/profile
```


# 三、创建服务
```
vi /lib/systemd/system/redis.service



参考文档：

http://www.144d.com/post-583.html
```
