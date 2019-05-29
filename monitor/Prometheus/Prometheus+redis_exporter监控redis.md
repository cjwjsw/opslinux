# 一、redis_exporter安装及配置
```
#下载地址
https://github.com/oliver006/redis_exporter/releases

cd /usr/local/src/

export VER="1.0.0"
wget https://github.com/oliver006/redis_exporter/releases/download/v${VER}/redis_exporter-v${VER}.linux-amd64.tar.gz

tar -zxvf redis_exporter-v1.0.0.linux-amd64.tar.gz 

mv redis_exporter-v1.0.0.linux-amd64 /data0/prometheus/redis_exporter

chown -R prometheus.prometheus /data0/prometheus

```


# 二、创建redis_exporter.service的 systemd unit 文件
```
# 1、Centos7系统
cat <<EOF > /etc/systemd/system/redis_exporter.service
[Unit]
Description=redis_exporter
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/data0/prometheus/redis_exporter/redis_exporter \
  --log-format=txt \
  --namespace=redis \
  --web.listen-address=:9121 \
  --web.telemetry-path=/metrics
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF


# 2、Centos6系统

```

# 三、创建配置文件
```

ARGS="--log-format=txt \
--namespace=redis \
--web.listen-address=:9121 \
--web.telemetry-path=/metrics"
```

# 四、启动myslqd_exporter
```
systemctl daemon-reload
systemctl restart redis_exporter
systemctl status redis_exporter
systemctl enable redis_exporter

验证
curl localhost:9121/metrics
```

# 五、Prometheus server配置拉取数据

利用 Prometheus 的 static_configs 来拉取 redis_exporter 的数据。

编辑prometheus.yml文件，添加内容
```
cat prometheus.yml
  - job_name: mysql_node3
    static_configs:
      - targets: ['192.168.56.13:9104']
```
重启prometheus，然后在Prometheus页面中的Targets中就能看到新加入的mysql

# 六、MySQL exporter Dashboard 模板

```
https://grafana.com/dashboards/7362
```
搜索mysql的Grafana Dashboard，导入进去

参考资料：

https://computingforgeeks.com/how-to-monitor-redis-server-with-prometheus-and-grafana-in-5-minutes/
