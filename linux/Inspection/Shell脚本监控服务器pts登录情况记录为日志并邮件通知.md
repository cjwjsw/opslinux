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
    使用nali命令瞧一瞧:
```
nali  42.96.189.63
```
  查看一下环境变量nali在哪个目录下：
```
  如果nali命令得到的中文地名输入到log中或发送出去的邮件中为空或乱码，那可能是服务器、脚本的编码问题，请自行解决。下面说正事儿：
  
```
三、编写脚本

```
# vim  /mydata/bash_shell/ssh_login_monitor.sh

#!/bin/bash

echo
CommonlyIP=("139.168.55.6")                           #  常用ssh登陆服务器的IP地址,即IP白名单
SendToEmail=("opsadmin@rjl.com" "123456789@qq.com")   #  接收报警的邮箱地址

LoginInfo=`last | grep "still logged in" | head -n1`
UserName=`echo $LoginInfo | gawk '{print $1}'`
LoginIP=`echo $LoginInfo | gawk '{print $3}'`
LoginTime=`date +'%Y-%m-%d %H:%M:%S'`
LoginPlace=`/usr/local/bin/nali $LoginIP | gawk -F'[][]' '{print $2}'`
SSHLoginLog="/var/log/login_access.log"

for ip in ${CommonlyIP[*]}  # 判断登录的客户端地址是否在白名单中
do
    if [ "$LoginIP" == $ip ];then
        COOL="YES"
    fi
done

if [ "$COOL" == "YES" ];then
    echo "用户【 $UserName 】于北京时间【 $LoginTime 】登陆了服务器,其IP地址安全！" >> $SSHLoginLog
elif [ $LoginIP ];then
    echo "用户【 $UserName 】于北京时间【 $LoginTime 】登陆了服务器,其IP地址为【 $LoginIP 】,归属地【 $LoginPlace 】" | mail -s "【 通知 】 有终端SSH连上服务器了!" ${SendToEmail[*]}
    echo "用户【 $UserName 】于北京时间【 $LoginTime 】登陆了服务器,其IP地址为【 $LoginIP 】,归属地【 $LoginPlace 】" >> $SSHLoginLog
fi
echo
```
  
