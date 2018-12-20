# 一、Elasticsearch 相关 api 操作

## 1. 检查 es 集群健康状态
```bash
#bash命令
[root@localhost ~]# curl -XGET 'localhost:9200/_cat/health?v&pretty'
epoch      timestamp cluster       status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1545296116 03:55:16  elasticsearch yellow          1         1     15  15    0    0       15             0                  -                 50.0%

#kibana命令
GET /_cat/health?v

描述：可以看到红框范围内的值为 yellow，它代表了我们 es 服务集群的健康状态，详细描述如下。解读后我们可以了解到，我们的 yellow 状态对于日常使用没有影响，它只是因为我们的集群暂时由单节点服务器组成，没有多余的节点分配给我们的分片副本了，解决示例会在以后的文章中给出。

RED: Damnit. Some or all of (primary) shards are not ready.
YELLOW: Elasticsearch has allocated all of the primary shards, but some/all of the replicas have not been allocated.
GREEN: Great. Your cluster is fully operational. Elasticsearch is able to allocate all shards and replicas to machines within the cluster.
```

## 2. 获取集群中的节点列表
```
```


参考文档： https://www.cnblogs.com/Wddpct/archive/2017/03/26/6623191.html
