# 一、node_exporter安装及配置
```
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.11.0/mysqld_exporter-0.11.0.linux-amd64.tar.gz

mv mysqld_exporter-0.11.0.linux-amd64 /data0/prometheus/mysqld_exporter

chown -R prometheus.prometheus /data0/prometheus

#赋权
mysqld_exporter需要连接到Mysql，所以需要Mysql的权限，我们先为它创建用户并赋予所需的权限：

CREATE USER 'exporter'@'localhost' IDENTIFIED BY '123456' WITH MAX_USER_CONNECTIONS 3;
GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter'@'localhost';

```

# 二、创建配置文件
```
cd /data0/prometheus/mysqld_exporter
cat << EOF > my.cnf
[client]
user=exporter
password=123456
EOF
```

# 三、创建mysqld_exporter.service的 systemd unit 文件
```
cat <<EOF > /etc/systemd/system/mysqld_exporter.service
[Unit]
Description=mysqld_exporter
After=network.target

[Service]
Type=simple
User=prometheus
ExecStart=/data0/prometheus/mysqld_exporter --config.my-cnf=/data0/prometheus/mysqld_exporter/my.cnf
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
```

# 四、启动myslqd_exporter
```
systemctl daemon-reload
systemctl start mysqld_exporter
systemctl status mysqld_exporter
systemctl enable mysqld_exporter

验证
curl localhost:9104/metrics
```



参考资料：

https://mp.weixin.qq.com/s?__biz=MzI1NjkzNDU4OQ==&mid=2247483975&idx=1&sn=9607317215ed8252968083cf09b9762d&scene=21%23wechat_redirect    构建狂拽炫酷屌的 MySQL 监控平台 
