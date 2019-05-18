# 一、安装
```
cd /usr/local/src
wget http://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.16.0-1.el7.ngx.x86_64.rpm
rpm -Uvh nginx-1.16.0-1.el7.ngx.x86_64.rpm 
```

# 二、启动
```
systemctl restart nginx

systemctl enable nginx
```
