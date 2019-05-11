# 一、下载安装包
```
cd /tmp/
wget -O /tmp/paping_1.5.5_x86-64_linux.tar.gz https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/paping/paping_1.5.5_x86-64_linux.tar.gz
tar -zxvf paping_1.5.5_x86-64_linux.tar.gz
```

# 二、测试
```
./paping -p 80 -c 10 www.baidu.com
```

# 三、
```
root># netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
LAST_ACK 6
SYN_RECV 21
ESTABLISHED 176
TIME_WAIT 2619
```

参考资料：

https://www.cnblogs.com/sysk/p/6427804.html

https://blog.csdn.net/enweitech/article/details/79261439  网络优化之net.ipv4.tcp_tw_recycle参数
