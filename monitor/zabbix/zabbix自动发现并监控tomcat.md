# 一、安装依赖
```
cd /tmp/
wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install --upgrade pip --trusted-host mirrors.aliyun.com -i https://mirrors.aliyun.com/pypi/simple/
pip install simplejson --trusted-host mirrors.aliyun.com -i https://mirrors.aliyun.com/pypi/simple/  
```
# 二、编写自动发现脚本

tomcat_name_discovery.py

```
#!/usr/bin/env python 
# -*- coding: UTF-8 -*-
import os
import subprocess
import simplejson as json

TOMCAT_HOME="/data0/opt"
# TOMCAT_NAME 自定义项目运行的tomcat的目录名称

TOMCAT_NAME="/bin/find %s -name 'server.xml' | sort -n | uniq -c | awk -F'/' '{print $4}'"%(TOMCAT_HOME)

#t=subprocess.Popen(args,shell=True,stdout=subprocess.PIPE).communicate()[0]
t=subprocess.Popen(TOMCAT_NAME,shell=True,stdout=subprocess.PIPE).communicate()[0]

tomcats=[]

for tomcat in t.split('\n'):
    if len(tomcat) != 0:
        tomcats.append({'{#TOMCAT_NAME}':tomcat})

# 打印出zabbix可识别的json格式
print json.dumps({'data':tomcats},sort_keys=True,indent=4,separators=(',',':'))
```

# 三、测试运行结果
```
one-app-05<2019-05-21 08:35:32> /etc/zabbix/scripts
root># ./tomcat_name_discovery.py 
{
    "data":[
        {
            "{#TOMCAT_NAME}":"tomcat8_8080_job"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8081_taskjob"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8082_schedule"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8083_inner"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8084_match"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8085_openapi"
        },
        {
            "{#TOMCAT_NAME}":"tomcat8_8086_console"
        }
    ]
}
```

# 四、客户端配置
在客户端配置文件中添加自定义的监控项key，示例如下：
```
cd /etc/zabbix/zabbix_agentd.d/

cat userparameter_tomcat.conf
# 变量1的key定义为：tomcat.name.discovery, 是脚本自动发现的tomcat实例名称，获取途径是执行tomcat_name_discovery.py
UserParameter=tomcat.name.discovery, /etc/zabbix/scripts/tomcat_name_discovery.py
```


参考文档：

https://segmentfault.com/a/1190000014808036   zabbix监控tomcat多实例（自动发现，主动模式）
