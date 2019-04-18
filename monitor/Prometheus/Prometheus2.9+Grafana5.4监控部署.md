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

4、创建prometheus.service 的 systemd unit 文件
```
cat > /etc/systemd/system/prometheus.service <<EOF
[Unit]
Description=Prometheus
Documentation=https://prometheus.io/
After=network.target
 
[Service]
Type=simple
User=prometheus
ExecStart=/data0/prometheus/bin/prometheus --config.file=/data0/prometheus/config/prometheus.yml --storage.tsdb.path=/data0/prometheus/data
Restart=on-failure
 
[Install]
WantedBy=multi-user.target
EOF
```

5、启动服务
```
systemctl daemon-reload
systemctl enable prometheus.service
systemctl start prometheus.service
```

6、运行状态
```
systemctl status prometheus.service
```
7、查看ui

Prometheus自带有简单的UI, http://192.168.56.11:9090/

```
http://192.168.56.11:9090/targets
http://192.168.56.11:9090/graph
```

# 二、node_exporter安装及配置

1、下载及解压安装包
```
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz

#mkdir -p /data0/prometheus 
#groupadd prometheus
#useradd -g prometheus prometheus -d /data0/prometheus
 
tar -xvf node_exporter-0.17.0.linux-amd64.tar.gz
cd /usr/local/src/
mv node_exporter-0.17.0.linux-amd64 /data0/prometheus/node_exporter
 
chown -R prometheus.prometheus /data0/prometheus
```


参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署
