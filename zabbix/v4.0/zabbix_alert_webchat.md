## 一、申请微信企业公众号的团体号

参考链接：

http://blog.51cto.com/itnihao/1733245

## 二、配置微信告警
```
git clone https://github.com/Lancger/Wechat-Alert-for-Zabbix.git

cp /tmp/Wechat-Alert-for-Zabbix/wechat_alert.py /usr/lib/zabbix/alertscripts

chown zabbix.zabbix /usr/lib/zabbix/alertscripts/wechat_alert.py

chmod +x /usr/lib/zabbix/alertscripts/wechat_alert.py


```

## 三、模拟告警
```
1、允许ping

echo 0 >/proc/sys/net/ipv4/icmp_echo_ignore_all

2、禁止ping

echo 1 >/proc/sys/net/ipv4/icmp_echo_ignore_all

```
