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
    
    
注意，这里的now 是es自动获取的时间
```
# 二、运行结果
```
python res_new.py agent-statistics-2018.12.21 310003258

{'query': {'range': {'time': {'lt': '2018-12-21 17:20:47'}}}, '_source': ['sn', 'source', 'epod.state']}
{u'source': u'/data/log/statistics/task.log', u'sn': u'C002116', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'B364348', u'epod': {u'state': 400}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'1134851', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'C013054', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'A143240', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'1222146', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'1248760', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'B367195', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'C223570', u'epod': {u'state': 200}}
{u'source': u'/data/log/statistics/task.log', u'sn': u'C046516', u'epod': {u'state': 200}}
```
