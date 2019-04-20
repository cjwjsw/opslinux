# 一、安装 Redis

```
#1、下载，解压，编译安装
cd /opt
wget http://download.redis.io/releases/redis-4.0.1.tar.gz
tar xzf redis-4.0.1.tar.gz
cd redis-4.0.1
make

#2、如果因为上次编译失败，有残留的文件
make distclean

```
