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

```

参考文档：

https://segmentfault.com/a/1190000014808036   zabbix监控tomcat多实例（自动发现，主动模式）
