# 一、带时间参数范围查询
```
cat res_new.py 

#!/usr/bin/env python
# _*_ coding:utf-8 _*_

from datetime import datetime
from elasticsearch import Elasticsearch
import json
import sys

es = Elasticsearch([{'host':'10.33.99.31','port':9200}])

index = sys.argv[1]
sn = sys.argv[2]
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print now

#范围匹配所需字段查询
args = {
    "query": {
        "range" : {
            "time": {
                "lt": now
            }
        }
    },
    "_source" : ["sn","source","epod.state"]
}

print args
resp = es.search(index, body=args)
resp_docs = resp['hits']['hits']

for item in resp_docs:
    print(item['_source'])
```
