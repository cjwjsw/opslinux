# 一、安装依赖

```
yum -y install automake
yum -y install libtool
yum -y install autoconf
yum -y install bzip2
```

# 二、软件编译安装
```
官方链接：https://github.com/vipshop/redis-migrate-tool
软件编译安装：

cd /usr/local/src/
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


参考资料：

https://blog.51cto.com/qiangsh/2104767?utm_source=oschina-app  Redis Cluster在线迁移

https://blog.51cto.com/8370646/2170479  redis迁移工具redis-migrate-tool测试
