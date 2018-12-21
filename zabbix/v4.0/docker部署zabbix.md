# 一、docker安装zabbix 4.0.1版本

容器化zabbix。

容器部署zabbix更简单

准备两台机器：
192.168.56.138 zabbix-server
192.168.56.131 zabbix-agent

软件版本：
docker: 18.06.1-ce
zabbix: 4.0.1

安装docker可以使用阿里镜像源的repo安装：
https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

开始部署zabbix：
192.168.56.138上操作：
