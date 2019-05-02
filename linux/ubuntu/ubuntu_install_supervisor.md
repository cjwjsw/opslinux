# 一、安装
```
sudo apt-get install supervisor -y
systemctl enable supervisor
systemctl restart supervisor

systemctl status supervisor
ps -ef|grep supervisor

#完整配置
sudo tee /etc/supervisor/supervisord.conf << 'EOF'
; supervisor config file

[unix_http_server]
file=/var/run/supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)

; the below section must remain in the config file for RPC
; (supervisorctl/web interface) to work, additional interfaces may be
; added by defining them in separate rpcinterface: sections
[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run/supervisor.sock ; use a unix:// URL  for a unix socket

; The [include] section can just contain the "files" setting.  This
; setting can list multiple files (separated by whitespace or
; newlines).  It can also contain wildcards.  The filenames are
; interpreted as relative to this file.  Included files *cannot*
; include files themselves.

[include]
files = /etc/supervisor/conf.d/*.conf
EOF
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
# vim /etc/supervisord.conf

[include]
files = /etc/supervisord.d/*.conf

新增测试配置
tee /etc/supervisord.d/hello.conf << 'EOF'
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


# 管理salt-master 
tee /etc/supervisord.d/salt-master.conf << 'EOF'
[program:salt-master]
command=/usr/bin/salt-master
autostart=true
autorestart=true
EOF

# 管理salt-minion
tee /etc/supervisord.d/salt-minion.conf << 'EOF'
[program:salt-minion]
command=/usr/bin/salt-minion
autostart=true
autorestart=true
EOF

#查看管理的服务
supervisorctl status

supervisorctl start salt-master
```

参考资料：

https://blog.csdn.net/DongGeGe214/article/details/80264811  
