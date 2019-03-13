## 一、通知脚本
```
vim /etc/ssh/sshrc
```
```
#!/bin/bash
###V1-2019-03-13###

CropID='aaaaa'
Secret='HeD64P1nPSTWaUhp_Yne_MY7IsA7lhF-EUZaCOmb_gY'
GURL="https://qyapi.weixin.qq.com/cgi-bin/gettoken?corpid=$CropID&corpsecret=$Secret"
Gtoken=$(/usr/bin/curl -s -G $GURL | jq -r '.access_token')
PURL="https://qyapi.weixin.qq.com/cgi-bin/message/send?access_token=$Gtoken"

LoginInfo=`last | grep "still logged in" | head -n1`
UserName=`echo $LoginInfo | gawk '{print $1}'`
LoginIP=`echo $LoginInfo | gawk '{print $3}'`
LoginTime=`date +'%Y-%m-%d %H:%M:%S'`
LoginPlace=`/usr/local/bin/nali $LoginIP | gawk -F'[][]' '{print $2}'`

function body() {
        local int appId=1000003
        #local userId=$1
        local userId="LinYouYi"
        local partyId=2
        local msg='有用户上线请注意:\n主机名：'`hostname`'\n主机ip：'`curl ifconfig.me`'\n登录用户：'`whoami`'\n来源IP：'$LoginIP'\n归属地：'$LoginPlace'\n登录时间：'$LoginTime
        printf '{\n'
        printf '\t"touser":"'"$userId"\"",\n"
        printf '\t"toparty":"'"$partyId"\"",\n"
        printf '\t"msgtype": "text",'"\n"
        printf '\t"agentid":"'"$appId"\"",\n"
        printf '\t"text":{\n'
        printf '\t\t"content":"'"$msg"\"
        printf '\n\t},\n'
        printf '\t"safe":"0"\n'
        printf '}\n'
}
/usr/bin/curl -s -o /dev/null --data-ascii "$(body)" $PURL
```

## 效果


参考文档：

https://www.cnblogs.com/linyouyi/p/9845843.html
