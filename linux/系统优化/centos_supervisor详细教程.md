# 一、安装
```
yum install -y epel-release supervisor
systemctl enable supervisord     # 开机自启动
systemctl restart supervisord    # 启动supervisord服务

systemctl status supervisord     # 查看supervisord服务状态
ps -ef|grep supervisord          # 查看是否存在supervisord进程

创建supervisor配置文件
echo_supervisord_conf > /etc/supervisord.conf

```


# 二、配置supervisord开机启动

```
sudo tee /usr/lib/systemd/system/supervisord.service << 'EOF'
[Unit]
Description=Supervisor daemon 

[Service]
Type=forking
ExecStart=/bin/supervisord -c /etc/supervisord.conf
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
systemctl status supervisord
```

# 三、测试
```
修改
;[include]
files = /etc/supervisord.d/*.ini

新增测试配置
tee /etc/supervisord.d/hello.ini << 'EOF'
[program:hello]
directory=/root                      ; 运行程序时切换到指定目录
command=/bin/bash hello.sh           ; 执行程序 ( 程序不能时后台运行的方式 )
autostart=true                       ; 程序随 supervisord 启动而启动
startsecs=10                         ; 程序启动 10 后没有退出，认为程序启动成功 
redirect_stderr=true                 ; 标准错误输出重定向到标准输出
stdout_logfile=/tmp/hello.log      ; 指定日志文件路径，可以绝对路径 ( 相对路径 相对 directory= 指定的目录 )
stdout_logfile_maxbytes=50MB         ; 文件切割大小
stdout_logfile_backups=10            ; 保留的备份数
EOF
```

参考资料：

https://blog.csdn.net/DongGeGe214/article/details/80264811  
