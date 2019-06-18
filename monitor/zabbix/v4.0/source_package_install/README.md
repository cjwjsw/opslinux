# 一、安装zabbix_server

```
cd /tmp && wget -O /tmp/install_zabbix_server_v4.0.sh https://raw.githubusercontent.com/Lancger/opslinux/master/monitor/zabbix/v4.0/%E6%BA%90%E7%A0%81%E5%AE%89%E8%A3%85/install_zabbix_server_v4.0.sh && chmod +x /tmp/install_zabbix_server_v4.0.sh && sh /tmp/install_zabbix_server_v4.0.sh
```

# 二、安装zabbix_proxy
```
cd /tmp && wget -O /tmp/install_zabbix_proxy_v4.0.sh https://raw.githubusercontent.com/Lancger/opslinux/master/monitor/zabbix/v4.0/%E6%BA%90%E7%A0%81%E5%AE%89%E8%A3%85/install_zabbix_proxy_v4.0.sh && chmod +x /tmp/install_zabbix_proxy_v4.0.sh && sh /tmp/install_zabbix_proxy_v4.0.sh

*特别提醒注意的一点是，新版的mysql数据库下的user表中已经没有Password字段了

而是将加密后的用户密码存储于authentication_string字段

skip-grant-tables

alter user 'root'@'localhost' identified by '123456';

SET PASSWORD = PASSWORD('123456');
```

# 三、安装zabbix_agent
```
cd /tmp && wget -O /tmp/install_zabbix_agent_v4.0.sh https://raw.githubusercontent.com/Lancger/opslinux/master/monitor/zabbix/v4.0/%E6%BA%90%E7%A0%81%E5%AE%89%E8%A3%85/install_zabbix_agent_v4.0.sh && chmod +x /tmp/install_zabbix_agent_v4.0.sh && sh /tmp/install_zabbix_agent_v4.0.sh
```

参考资料：

https://www.cnblogs.com/biaopei/p/9877747.html zabbix4.0离线快速编译安装（编译安装方法）

https://www.cnblogs.com/uglyliu/p/10143914.html Centos7一键编译安装zabbix-4.0.2
