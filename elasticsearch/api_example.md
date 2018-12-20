# 一、案例
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
# 二、运行结果
```
[{u'_score': 0.30685282, u'_type': u'external', u'_id': u'2', u'_index': u'customer', u'_source': {u'age': 20, u'name': u'Tom'}}]
Tom
```
# 三、原始数据
```
[root@localhost ~]# curl -XGET 'localhost:9200/customer/external/_search?pretty' -H 'Content-Type: application/json' -d'
> {
>     "query": {
>         "match" : {
>             "name":"Tom"
>         }
>     }
> }
> '
{
  "took" : 5,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 0.30685282,
    "hits" : [ {
      "_index" : "customer",
      "_type" : "external",
      "_id" : "2",
      "_score" : 0.30685282,
      "_source" : {
        "name" : "Tom",
        "age" : 20
      }
    } ]
  }
}
```
