# 一、Prometheus概述

Prometheus是一个开源的系统监视和警报工具包，自2012成立以来，许多公司和组织采用了Prometheus。它现在是一个独立的开源项目，并独立于任何公司维护。
在2016年，Prometheus加入云计算基金会作为Kubernetes之后的第二托管项目。

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
