 # Shell脚本监控服务器pts登录情况记录为日志并邮件通知
 
## 一、配置服务器sendmail发邮件功能
 
 安装sendmail服务：
```sh
yum  install  sendmail  -y
```

 下面启动sendmail服务：
```sh
/etc/init.d/sendmail  restart
```

启动后请单独用mail -s测试邮件是否可以发送出去，此处不介绍了。

## 二、Linux下用nali查询IP地址归属地：
  
  下载nali的tar包：
```sh
wget  http://chenze.name/wenjian/nali-0.2.tar.gz
```

  解压，并放到合适位置：
```sh
tar  xvf nali-0.2.tar.gz
mv  nali-0.2  /mydata/nali
```

  编译安装：
```sh
cd  /mydata/nali
./configure
make  &&  make  install
```

  更新本地nali地址库（建议制定计划任务，每天自动更新一次IP地址库）：
```sh
nali-update
```
