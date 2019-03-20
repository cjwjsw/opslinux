## 一、什么是ELFK

&#8195;&#8195;ELK已经成为目前最流行的集中式日志解决方案，分别表示：Elasticsearch , Logstash, Kibana , 它们都是开源软件。新增了一个FileBeat，它是一个轻量级的日志收集处理工具(Agent)，Filebeat占用资源少，适合于在各个服务器上搜集日志后传输给Logstash，官方也推荐此工具。

&#8195;&#8195;Elasticsearch是个开源分布式搜索引擎，提供搜集、分析、存储数据三大功能。它的特点有：分布式，零配置，自动发现，索引自动分片，索引副本机制，restful风格接口，多数据源，自动搜索负载等。

&#8195;&#8195;Logstash 主要是用来日志的搜集、分析、过滤日志的工具，支持大量的数据获取方式。一般工作方式为c/s架构，client端安装在需要收集日志的主机上，server端负责将收到的各节点日志进行过滤、修改等操作在一并发往elasticsearch上去。

&#8195;&#8195;Kibana 也是一个开源和免费的工具，Kibana可以为 Logstash 和 ElasticSearch 提供的日志分析友好的 Web 界面，可以帮助汇总、分析和搜索重要数据日志。

&#8195;&#8195;Filebeat隶属于Beats。目前Beats包含四种工具：
```
    1、Packetbeat（搜集网络流量数据）
    2、Topbeat（搜集系统、进程和文件系统级别的 CPU 和内存使用情况等数据）
    3、Filebeat（搜集文件数据）
    4、Winlogbeat（搜集 Windows 事件日志数据）
```


## 二、ELK常见部署架构

2.1 Logstash作为日志收集器

这种架构是比较原始的部署架构，在各应用服务器端分别部署一个Logstash组件，作为日志收集器，然后将Logstash收集到的数据过滤、分析、格式化处理后发送至Elasticsearch存储，最后使用Kibana进行可视化展示，这种架构不足的是：Logstash比较耗服务器资源，所以会增加应用服务器端的负载压力。


2.2 Filebeat作为日志收集器

该架构与第一种架构唯一不同的是：应用端日志收集器换成了Filebeat，Filebeat轻量，占用服务器资源少，所以使用Filebeat作为应用服务器端的日志收集器，一般Filebeat会配合Logstash一起使用，这种部署方式也是目前最常用的架构。

2.3 引入缓存队列的部署架构

该架构在第二种架构的基础上引入了Kafka消息队列（还可以是其他消息队列），将Filebeat收集到的数据发送至Kafka，然后在通过Logstasth读取Kafka中的数据，这种架构主要是解决大数据量下的日志收集方案，使用缓存队列主要是解决数据安全与均衡Logstash与Elasticsearch负载压力。

参考文档：

https://www.kemin-cloud.com/?p=130
