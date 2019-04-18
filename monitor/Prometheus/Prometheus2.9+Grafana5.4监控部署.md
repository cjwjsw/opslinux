# 一、Prometheus安装及配置
```
wget https://github.com/prometheus/prometheus/releases/download/v2.9.1/prometheus-2.9.1.linux-amd64.tar.gz

mkdir -p /data0/prometheus 
groupadd prometheus
useradd -g prometheus prometheus -d /data0/prometheus
 
tar -xvf prometheus-2.9.1.linux-amd64.tar.gz
cd /usr/local/src/
mv prometheus-2.9.1.linux-amd64/* /data0/prometheus/
 
cd /data0/prometheus/
mkdir -p {data,cfg,logs,bin} 
mv prometheus promtool bin/
mv prometheus.yml cfg/
 
chown -R prometheus.prometheus /data0/prometheus
```


参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署
