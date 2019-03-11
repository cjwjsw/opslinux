## 替换前
```
[root@localhost path]# cat /etc/profile
export GOROOT=/usr/local/go
export PATH=$PATH:$TEST
export GOPATH=/opt/path/

替换命令
sed -i 's#export PATH=$PATH.*#export PATH=$PATH:$GOROOT/bin:$GOPATH/bin#g' /etc/profile
```
## 替换后
```
[root@localhost path]# cat /etc/profile

export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export GOPATH=/opt/path/
```
