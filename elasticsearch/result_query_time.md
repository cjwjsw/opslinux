```
#!/usr/bin/env python
# _*_ coding:utf-8 _*_

from datetime import datetime
from elasticsearch import Elasticsearch
import json
import sys

es = Elasticsearch([{'host':'10.33.99.31','port':9200,}])

index = sys.argv[1]
key1 = sys.argv[2]
key2 = sys.argv[3]
now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
print now

#范围匹配所需字段查询
args = {
    "size": 10000,
    "query": { 
      "bool": { 
        "must": [
          { "match": { "cpod.state":   key1 }}, 
          { "match": { "cpod.code":    key2 }}  
        ],
        "filter": [ 
          { "range": { "time": { "lte": "now" }}} 
        ]
      }
    }
}

print args
resp = es.search(index, body=args)
resp_docs = resp['hits']['hits']

for item in resp_docs:
    print(item)
```
