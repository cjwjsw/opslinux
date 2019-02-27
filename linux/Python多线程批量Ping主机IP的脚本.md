## 一、Python多线程批量Ping主机IP的脚本

脚本内容
```
#!/usr/bin/env python
# -*- coding: utf-8 -*-  
import subprocess
import time

# import sys
# reload(sys)
# sys.setdefaultencoding('utf-8')

# 记录开始执行的时间
start_time = time.time()

# 定义用来 ping 的254 个 ip
ip_list = ['192.168.56.'+str(i) for i in range(1,255)]  

for ip in ip_list:
    res = subprocess.call('ping -c 2 -w 5 %s' % ip, stdout=subprocess.PIPE, shell=True)
    print (ip,True if res == 0 else False)

print('执行所用时间：%s' % (time.time() - start_time))
```
执行结果
