# 一、安装
```
yum install -y epel-release supervisor
systemctl enable supervisord     # 开机自启动
systemctl restart supervisord    # 启动supervisord服务

systemctl status supervisord     # 查看supervisord服务状态
ps -ef|grep supervisord          # 查看是否存在supervisord进程
```


参考资料：

https://blog.csdn.net/DongGeGe214/article/details/80264811  
