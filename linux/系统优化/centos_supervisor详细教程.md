# 一、安装
```
yum install -y epel-release supervisor
systemctl enable supervisord     # 开机自启动
systemctl restart supervisord    # 启动supervisord服务

systemctl status supervisord     # 查看supervisord服务状态
ps -ef|grep supervisord          # 查看是否存在supervisord进程
```


# 二、配置supervisord开机启动

```
sudo tee /usr/lib/systemd/system/supervisord.service << 'EOF'
[Unit]
Description=Supervisor daemon 

[Service]
Type=forking
ExecStart=/bin/supervisord -c /etc/supervisor/supervisord.conf
ExecStop=/bin/supervisorctl shutdown
ExecReload=/bin/supervisorctl reload
KillMode=process
Restart=on-failure
RestartSec=42s 

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl restart supervisord
systemctl enable supervisord
systemctl is-enabled supervisord
```


参考资料：

https://blog.csdn.net/DongGeGe214/article/details/80264811  
