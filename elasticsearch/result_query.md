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
## 查询结果
```
[root@localhost ~]# python result_query.py
{u'age': 20, u'name': u'Tom'}
```

# 二、范围查询
```
[root@localhost ~]# cat result_multi.py
#!/usr/bin/env python
# _*_ coding:utf-8 _*_

from datetime import datetime
from elasticsearch import Elasticsearch
import json

es = Elasticsearch()

index = "customer"

#范围匹配
query = {
"query":{
    "range":{
       "age":{
          "gte": 10,
          "lt": 30
        }
      }
   }
}

resp = es.search(index, body=query)
resp_docs = resp['hits']['hits']

for item in resp_docs:
    print(item['_source'])
```
## 查询结果
```
[root@localhost ~]# python result_multi.py
{u'age': 20, u'name': u'Tom'}
```

参考资料:

https://www.cnblogs.com/kongzhagen/p/7899346.html
