## 一、一线公司ES使用场景：

1）新浪ES 如何分析处理32亿条实时日志 http://dockone.io/article/505 

2）阿里ES 构建挖财自己的日志采集和分析体系 http://afoo.me/columns/tec/logging-platform-spec.html 

3）有赞ES 业务日志处理 http://tech.youzan.com/you-zan-tong-ri-zhi-ping-tai-chu-tan/ 

4）ES实现站内搜索 http://www.wtoutiao.com/p/13bkqiZ.html

Elasticsearch研究有一段时间了，现特将Elasticsearch相关核心知识、原理从初学者认知、学习的角度，从以下9个方面进行详细梳理。欢迎讨论……

## 0. 带着问题上路——ES是如何产生的？

### （1）思考：大规模数据如何检索？

如：当系统数据量上了10亿、100亿条的时候，我们在做系统架构的时候通常会从以下角度去考虑问题： 

1）用什么数据库好？(mysql、sybase、oracle、达梦、神通、mongodb、hbase…) 

2）如何解决单点故障；(lvs、F5、A10、Zookeep、MQ) 

3）如何保证数据安全性；(热备、冷备、异地多活) 

4）如何解决检索难题；(数据库代理中间件：mysql-proxy、Cobar、MaxScale等;) 

5）如何解决统计分析问题；(离线、近实时)

### （2）传统数据库的应对解决方案

对于关系型数据，我们通常采用以下或类似架构去解决查询瓶颈和写入瓶颈： 
解决要点：

1）通过主从备份解决数据安全性问题； 

2）通过数据库代理中间件心跳监测，解决单点故障问题； 

3）通过代理中间件将查询语句分发到各个slave节点进行查询，并汇总结果 

  ![关系型数据库集群](https://github.com/Lancger/opslinux/blob/master/images/关系型db.png)


### （3）非关系型数据库的解决方案

对于Nosql数据库，以mongodb为例，其它原理类似： 
解决要点： 

1）通过副本备份保证数据安全性； 

2）通过节点竞选机制解决单点问题； 

3）先从配置库检索分片信息，然后将请求分发到各个节点，最后由路由节点合并汇总结果

  ![nosql数据库集群](https://github.com/Lancger/opslinux/blob/master/images/nosql.png)

### 另辟蹊径——完全把数据放入内存怎么样？

我们知道，完全把数据放在内存中是不可靠的，实际上也不太现实，当我们的数据达到PB级别时，按照每个节点96G内存计算，在内存完全装满的数据情况下，我们需要的机器是：1PB=1024T=1048576G 
节点数=1048576/96=10922个 
实际上，考虑到数据备份，节点数往往在2.5万台左右。成本巨大决定了其不现实！

从前面讨论我们了解到，把数据放在内存也好，不放在内存也好，都不能完完全全解决问题。 
全部放在内存速度问题是解决了，但成本问题上来了。 
为解决以上问题，从源头着手分析，通常会从以下方式来寻找方法： 

1、存储数据时按有序存储； 

2、将数据和索引分离； 

3、压缩数据； 
这就引出了Elasticsearch。

## 1. ES 基础一网打尽

### 1.1 ES定义

ES=elaticsearch简写， Elasticsearch是一个开源的高扩展的分布式全文检索引擎，它可以近乎实时的存储、检索数据；本身扩展性很好，可以扩展到上百台服务器，处理PB级别的数据。 
Elasticsearch也使用Java开发并使用Lucene作为其核心来实现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得简单。






参考文档：

https://blog.csdn.net/makang110/article/details/80596017
