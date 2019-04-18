# 一、Prometheus安装及配置
```
wget https://github.com/prometheus/prometheus/releases/download/v2.9.1/prometheus-2.9.1.linux-amd64.tar.gz

groupadd prometheus
useradd -g prometheus prometheus -d /app/prometheus
 
tar -xvf prometheus-2.5.0.linux-amd64.tar.gz
cd prometheus-2.5.0.linux-amd64/
mv * /app/prometheus/
 
cd /app/prometheus/
mkdir {data,cfg,logs,bin} -p
mv prometheus promtool bin/
mv prometheus.yml cfg/
 
chown -R prometheus.prometheus *
```
