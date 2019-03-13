 # Shell脚本监控服务器pts登录情况记录为日志并邮件通知
 
## 一、配置服务器sendmail发邮件功能
 
 安装sendmail服务：
```
yum  install  sendmail  -y
```

 下面启动sendmail服务：
```
/etc/init.d/sendmail  restart
```

启动后请单独用mail -s测试邮件是否可以发送出去，此处不介绍了。
