# 一、下载安装二进制包
```
从 github 发布地址下载最新的 binary 包：https://github.com/github/gh-ost/releases

https://github.com/github/gh-ost/releases

rpm -Uvh gh-ost-1.0.48-1.x86_64.rpm

[root@node1 src]# which gh-ost
/usr/bin/gh-ost
```

# 二、修改mysql日志格式
```
mysql> show variables like 'binlog_format';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| binlog_format | ROW   |
+---------------+-------+
1 row in set (0.00 sec)


mysql> set global binlog_format="ROW";
```


参考文档：

https://www.cnblogs.com/zhoujinyi/p/9187421.html  
