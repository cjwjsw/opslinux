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
systemctl restart prometheus.service
```

6、运行状态
```
systemctl status prometheus.service
```

7、prometheus.yml配置文件
```
[root@linux-node1 config]# cat prometheus.yml
# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['192.168.56.11:9090']
      labels:
        instance: prometheus_server

  - job_name: linux1
    static_configs:
      - targets: ['192.168.56.11:9100']
        labels:
          instance: sys1

  - job_name: linux2
    static_configs:
      - targets: ['192.168.56.12:9100']
        labels:
          instance: sys2

  - job_name: linux3
    static_configs:
      - targets: ['192.168.56.13:9100']
        labels:
          instance: sys3
```
8、查看ui

Prometheus自带有简单的UI, http://192.168.56.11:9090/

```
http://192.168.56.11:9090/targets
http://192.168.56.11:9090/graph
```

# 二、node_exporter安装及配置

1、下载及解压安装包
```
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz

mkdir -p /data0/prometheus 
groupadd prometheus
useradd -g prometheus prometheus -d /data0/prometheus
 
tar -xvf node_exporter-0.17.0.linux-amd64.tar.gz
cd /usr/local/src/
mv node_exporter-0.17.0.linux-amd64 /data0/prometheus/node_exporter
 
chown -R prometheus.prometheus /data0/prometheus
```

2、创建node_exporter.service的 systemd unit 文件
```
cat > /usr/lib/systemd/system/node_exporter.service <<EOF
[Unit]
Description=node_exporter
Documentation=https://prometheus.io/
After=network.target
 
[Service]
Type=simple
User=prometheus
ExecStart=/data0/prometheus/node_exporter/node_exporter
Restart=on-failure
 
[Install]
WantedBy=multi-user.target
EOF
```

3、启动服务
```
systemctl daemon-reload
systemctl enable node_exporter.service
systemctl restart node_exporter.service
```

4、运行状态
```
systemctl status node_exporter.service
```

5、客户监控端数据汇报

访问：http://192.168.56.11:9100/metrics  查看从exporter具体能抓到的数据.如下：

# 三、Grafana安装及配置

1、下载及安装
```
wget https://dl.grafana.com/oss/release/grafana-6.1.4-1.x86_64.rpm
yum localinstall grafana-6.1.4-1.x86_64.rpm

```

2、启动服务
```
systemctl daemon-reload
systemctl enable grafana-server.service
systemctl restart grafana-server.service
```

3、访问WEB界面

默认账号/密码：admin/admin
http://192.168.56.11:3000


4、Grafana添加数据源
```
在登陆首页，点击"Configuration-Data Sources"按钮，跳转到添加数据源页面，配置如下：
Name: prometheus
Type: prometheus
URL: http://192.168.56.11:9090
Access: Server
取消Default的勾选，其余默认，点击"Add"，如下：
```

# 四、替换grafana的dashboards

https://grafana.com/dashboards   
```

```

参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署

https://www.cnblogs.com/smallSevens/p/7805842.html    Grafana+Prometheus打造全方位立体监控系统 

https://www.cnblogs.com/sfnz/p/6566951.html安装prometheus+grafana监控mysql redis kubernetes等 
