## 一、zabbix-agentd配置文件
```
[root@web01 zabbix_agentd.d]# cat count_sn.conf 
################
#Author: Lancger
################
UserParameter=user.auto.login.count,ps -ef|grep -w ssh|grep -v grep|awk '{print $NF}'|wc -l


# 运行示例
[root@web01 zabbix_agentd.d]# ps -ef|grep -w ssh|grep -v grep|awk '{print $NF}'|wc -l
1
```

## 二、zabbix监控页面配置

