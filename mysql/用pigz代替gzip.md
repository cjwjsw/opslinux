# 一、安装
pigz简单的说，就是支持并行的gzip。废话不多说，开始测试。
```
#1、yum安装
yum -y install pigz

#2、编译安装
yum -y install zlib-devel
cd /usr/local/src/
wget http://zlib.net/pigz/pigz-2.4.tar.gz
tar zxvf pigz-2.4.tar.gz
cd pigz-2.4
make
cp pigz unpigz /usr/bin/
```


参考文档：

https://www.cnblogs.com/xianghang123/p/3729925.html
