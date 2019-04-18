# 一、Prometheus安装及配置

1、下载及解压安装包
```
wget https://github.com/prometheus/prometheus/releases/download/v2.9.1/prometheus-2.9.1.linux-amd64.tar.gz

mkdir -p /data0/prometheus 
groupadd prometheus
useradd -g prometheus prometheus -d /data0/prometheus
 
tar -xvf prometheus-2.9.1.linux-amd64.tar.gz
cd /usr/local/src/
mv prometheus-2.9.1.linux-amd64/* /data0/prometheus/
 
cd /data0/prometheus/
mkdir -p {data,config,logs,bin} 
mv prometheus promtool bin/
mv prometheus.yml config/
 
chown -R prometheus.prometheus /data0/prometheus
```
2 、设置环境变量
```
vim /etc/profile
PATH=/data0/prometheus/bin:$PATH:$HOME/bin
source /etc/profile
```

3、检查配置文件
```
promtool check config /data0/prometheus/config/prometheus.yml

Checking /data0/prometheus/config/prometheus.yml
  SUCCESS: 0 rule files found
```
参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署
