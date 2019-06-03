# 一、服务器连接状态统计
```
#方式一
[root@linux-node2 ~]# ss -ant | awk 'NR>=2 {++State[$1]} END {for (key in State) print key,State[key]}'
LISTEN 5
ESTAB 7
TIME-WAIT 2

#方式二
[root@linux-node2 ~]# netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
ESTABLISHED 7
TIME_WAIT 3
```
