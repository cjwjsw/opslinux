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

    1. prometheus server： 定期从静态配置的 targets 或者服务发现（主要是DNS、consul、k8s、mesos等）的 targets 拉取数据。
    
    2. exporters：负责向prometheus server做数据汇报的程序统。而不同的数据汇报由不同的exporters实现，比如监控主机有node-exporters，mysql有MySQL server exporter
    
    3. pushgateway：主要使用场景为：
       Prometheus 采用 pull 模式，可能由于不在一个子网或者防火墙原因，导致 Prometheus 无法直接拉取各个 target 数据。在监控业务数据的时候，需要将不同数据汇总, 由 Prometheus 统一收集。总结：实现类似于zabbix-proxy功能；
    
    4. Alertmanager：实现prometheus的告警功能。
     
    5. webui：主要通过grafana来实现webui展示。

架构图

  ![prometheus架构图](https://github.com/Lancger/opslinux/blob/master/images/prometheus.png)






Prometheus的基本原理是通过HTTP协议周期性抓取被监控组件的状态，任意组件只要提供对应的HTTP接口就可以接入监控。不需要任何SDK或者其他的集成过程。这样做非常适合做虚拟化环境监控系统，比如VM、Docker、Kubernetes等。输出被监控组件信息的HTTP接口被叫做exporter 。目前互联网公司常用的组件大部分都有exporter可以直接使用，比如Varnish、Haproxy、Nginx、MySQL、Linux系统信息(包括磁盘、内存、CPU、网络等等)。

参考文档：

https://blog.csdn.net/xiegh2014/article/details/84936174   CentOS7.5 Prometheus2.5+Grafana5.4监控部署

https://www.cnblogs.com/yanyouqiang/p/7240696.html   Prometheus入门 
