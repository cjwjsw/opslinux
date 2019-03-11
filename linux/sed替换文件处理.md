## 一、替换前
```
[root@localhost path]# cat /etc/profile
export GOROOT=/usr/local/go
export PATH=$PATH:$TEST
export GOPATH=/opt/path/

替换命令
sed -i 's#export PATH=$PATH.*#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin#g' /etc/profile
```
## 二、替换后
```
[root@localhost path]# cat /etc/profile

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPATH=/opt/path/
```

参考文档：

https://blog.csdn.net/sch0120/article/details/80323904   解决sed替换“路径”字符串的问题
