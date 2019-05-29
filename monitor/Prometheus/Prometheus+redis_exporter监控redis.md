# 一、redis_exporter安装及配置
```
#下载地址
https://github.com/oliver006/redis_exporter/releases

cd /usr/local/src/

tar -zxvf redis_exporter-v1.0.0.linux-amd64.tar.gz 

mv redis_exporter-v1.0.0.linux-amd64 /data0/prometheus/redis_exporter

chown -R prometheus.prometheus /data0/prometheus

```


# 二、创建redis_exporter.service的 systemd unit 文件
```
cat <<EOF > /etc/systemd/system/redis_exporter.service
[Unit]
Description=redis_exporter
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/data0/prometheus/redis_exporter/redis_exporter
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
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

利用 Prometheus 的 static_configs 来拉取 mysqld_exporter 的数据。

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

https://mp.weixin.qq.com/s?__biz=MzI1NjkzNDU4OQ==&mid=2247483975&idx=1&sn=9607317215ed8252968083cf09b9762d&scene=21%23wechat_redirect    构建狂拽炫酷屌的 MySQL 监控平台 

https://www.cnblogs.com/bigberg/p/10118215.html 

https://blog.csdn.net/hzs33/article/details/86553259  prometheus+grafana监控mysql、canal服务器
