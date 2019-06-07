# 一、检测磁盘类型
```
命令：
cat /sys/block/sda/queue/rotational
cat /sys/block/sdb/queue/rotational

注意：
命令中的sba是你的磁盘名称，可以通过df命令查看磁盘，然后修改成你要的


结果：
返回0：SSD盘
返回1：SATA盘
```


参考文档：

https://blog.csdn.net/daiyudong2020/article/details/51454831   linux查看磁盘是否SSD盘
