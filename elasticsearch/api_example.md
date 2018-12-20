# 案例
```
[root@localhost ~]# cat result.py
from datetime import datetime
from elasticsearch import Elasticsearch
import json

es = Elasticsearch()

res = es.count(index='customer')

body = {
"query":{
      "match":{
          "name": "Tom"
      }
    }
}

a = json.dumps(es.search(index="customer",body=body))
#result = es.search(index="customer",body=body)
b = json.loads(a)
res = b['hits']['hits']
print res
print res[0]['_source']['name']
```
