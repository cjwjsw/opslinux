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




参考文档：

https://blog.csdn.net/makang110/article/details/80596017
