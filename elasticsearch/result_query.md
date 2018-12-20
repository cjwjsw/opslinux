# 一、标准查询
```
[root@localhost ~]# cat result_query.py
#!/usr/bin/env python
# _*_ coding:utf-8 _*_

from datetime import datetime
from elasticsearch import Elasticsearch
import json

es = Elasticsearch()

index = "customer"

#标准匹配
query = {
"query":{
    "match":{
       "name":"Tom"
      }
   }
}

resp = es.search(index, body=query)
resp_docs = resp['hits']['hits']

for item in resp_docs:
    print(item['_source'])
```
# 二、查询结果
```
[root@localhost ~]# python result_query.py
{u'age': 20, u'name': u'Tom'}
```

参考资料:

https://www.cnblogs.com/kongzhagen/p/7899346.html
