# 一、安装依赖

```
yum -y install automake
yum -y install libtool
yum -y install autoconf
yum -y install bzip2
```

# 二、安装
```
官方链接：https://github.com/vipshop/redis-migrate-tool
软件编译安装：

mkdir /usr/local/src/  && cd /usr/local/src/
wget https://github.com/vipshop/redis-migrate-tool/archive/master.zip
unzip master.zip
mv redis-migrate-tool-master redis-migrate-tool
cd redis-migrate-tool
mkdir data
autoreconf -fvi
./configure
make
src/redis-migrate-tool -h
```
