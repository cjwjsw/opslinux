# 一、
```
chattr -i /etc/passwd* && chattr -i /etc/group* && chattr -i /etc/shadow*
groupadd prometheus
useradd -g prometheus prometheus -s /sbin/nologin -c "prometheus Daemons"
cd /usr/local/src/
mkdir -p /usr/local/prometheus/node_exporter/
wget -O /usr/local/src/node_exporter-0.17.0.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
tar -xvf node_exporter-0.17.0.linux-amd64.tar.gz
mv node_exporter-0.17.0.linux-amd64/* /usr/local/prometheus/node_exporter/
chown -R prometheus:prometheus /usr/local/prometheus/
mkdir -p /var/run/prometheus/
mkdir -p /var/log/prometheus/
chown prometheus:prometheus /var/run/prometheus/
chown prometheus:prometheus /var/log/prometheus/
touch /var/log/prometheus/node_exporter.log
chmod 777 /var/log/prometheus/node_exporter.log
chown prometheus:prometheus /var/log/prometheus/node_exporter.log
touch /etc/sysconfig/node_exporter.conf
cat > /etc/sysconfig/node_exporter.conf <<EOF
ARGS=""
EOF
/etc/init.d/node_exporter start
chkconfig node_exporter on
```

# 二、启动脚本
```

```
参考文档：

https://www.veryarm.com/19670.html  
