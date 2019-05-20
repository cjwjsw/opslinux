    公司业务使用activemq5.9.1消息队列，由于队列阻塞导致程序端口无响应，并且telnet无法连通。经过over 1 hour的排查，最终定位原因activemq导致。遂写了一个监控activemq队列信息的脚本。
    
# 一、脚本部分
```
[root@localhost ~]# cat activemqqueue.sh 
#!/bin/bash
#author：xkops
#define common info
HOST=10.44.144.92
PORT=8161
USER=admin
PASSWORD=admin

#obtain queue's Pending,Consumers,Enqueued,Dequeued
function Queue()
{
  Count=$(curl -u"$USER":"$PASSWORD" http://$HOST:$PORT/admin/queues.jsp 2> /dev/null |grep -A 5 "^$1"|grep -oP '\d+');
  #echo $Count
  Pending=$(echo $Count |awk '{print $1}');
  #echo $Count
  Consumers=$(echo $Count |awk '{print $2}');
  Enqueued=$(echo $Count |awk '{print $3}');
  Dequeued=$(echo $Count |awk '{print $4}');
  #EndeltaDn=$(($Enqueued - $Dequeued))
  #echo '-------------'
  #echo -e "$Pending\n$Consumers\n$Enqueued\n$Dequeued";
  #echo "$2"
  if [ "$2" = '' ];then
     exit
  fi
  if [ "$2" = 'Pending' ];then
    echo $Pending
  elif [ "$2" = 'Consumers' ];then
    echo $Consumers
  elif [ "$2" = 'Enqueued' ];then
    echo $Enqueued
  #elif [ "$2" = 'EndeltaDn' ];then
  #  echo $EndeltaDn
  else
    echo $Dequeued
  fi
}

#call function and input queue_name queue_type
Queue $1 $2
```

参考文档：

https://www.cnblogs.com/xkops/p/5591983.html  zabbix监控activemq队列脚本

https://www.cnblogs.com/yexiaochong/p/6149700.html   Zabbix 监控rabbitmq
