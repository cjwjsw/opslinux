# 一、什么是TSDB？

TSDB(Time Series Database)时序列数据库，我们可以简单的理解为一个优化后用来处理时间序列数据的软件，并且数据中的数组是由时间进行索引的。

1、时间序列数据库的特点

    大部分时间都是写入操作。

    写入操作几乎是顺序添加，大多数时候数据到达后都以时间排序。

    写操作很少写入很久之前的数据，也很少更新数据。大多数情况在数据被采集到数秒或者数分钟后就会被写入数据库。

    删除操作一般为区块删除，选定开始的历史时间并指定后续的区块。很少单独删除某个时间或者分开的随机时间的数据。

    基本数据大，一般超过内存大小。一般选取的只是其一小部分且没有规律，缓存几乎不起任何作用。

    读操作是十分典型的升序或者降序的顺序读。

    高并发的读操作十分常见。

2、常见的时间序列数据库
```
TSDB项目    官网
influxDB    https://influxdata.com/
RRDtool    http://oss.oetiker.ch/rrdtool/
Graphite    http://graphiteapp.org/
OpenTSDB    http://opentsdb.net/
Kdb+    http://kx.com/
Druid    http://druid.io/
KairosDB    http://kairosdb.github.io/
Prometheus    https://prometheus.io/
```

# 二、Prometheus概述

Prometheus是由SoundCloud开发的开源监控报警系统和时序列数据库(TSDB)，它使用Go语言开发，是一个开源的系统监视和警报工具包，自2012成立以来，许多公司和组织采用了Prometheus。它现在是一个独立的开源项目，并独立于任何公司维护。Prometheus和Heapster(Heapster是K8S的一个子项目，用于获取集群的性能数据。)相比功能更完善、更全面。Prometheus性能也足够支撑上万台规模的集群。

特点：

    多维数据模型（有metric名称和键值对确定的时间序列）
    灵活的查询语言
    不依赖分布式存储
    通过pull方式采集时间序列，通过http协议传输
    支持通过中介网关的push时间序列的方式
    监控数据通过服务或者静态配置来发现
    支持图表和dashboard等多种方式

组件：

    Prometheus 主程序，主要是负责存储、抓取、聚合、查询方面。
    Alertmanager 程序，主要是负责实现报警功能。
    Pushgateway 程序，主要是实现接收由Client push过来的指标数据，在指定的时间间隔，由主程序来抓取。
    node_exporter 这类是不同系统已经实现了的集成。

架构图






参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署

https://www.cnblogs.com/yanyouqiang/p/7240696.html   Prometheus入门 
