## 搭建ELFK日志采集系统

最近的工作涉及搭建一套日志采集系统，采用了业界成熟的ELFK方案，这里将搭建过程记录一下。
环境准备
操作系统信息

系统系统：centos7.2

三台服务器：10.211.55.11/12/13

安装包：

https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.3.2.rpm

https://artifacts.elastic.co/downloads/kibana/kibana-6.3.2-x86_64.rpm

https://artifacts.elastic.co/downloads/logstash/logstash-6.3.2.rpm

https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.3.2-x86_64.rpm


服务器规划

# 使用手册
<table border="0">
    <tr>
        <td><strong>服务器HOST1</strong></td>
        <td><strong><a >服务器host2</a></td>
        <td><strong><a >服务器host3</a></td>
    </tr>
    <tr>        
        <td><a >elasticsearch(master,data,client)</a></td>
        <td><a >elasticsearch(master,data,client)</a></td>
        <td><a >elasticsearch(master,data,client)</a></td>
    </tr>
    <tr>
        <td><a >kibana</a></td>
        <td><a ></a></td>
        <td><a ></a></td>
    </tr>
    <tr>
        <td><a >logstash</a></td>
        <td><a >logstash</a></td>
        <td><a >logstash</a></td>
    </tr>
    <tr>
        <td><a >filebeat</a></td>
        <td><a >filebeat</a></td>
        <td><a >filebeat</a></td>
    </tr>
</table>


## 整个ELFK的部署架构图大致如下图：

![ELFK架构](https://github.com/Lancger/opslinux/blob/master/images/ELFK.png)

## 日志采集系统搭建

安装elasticsearch集群

照手把手教你搭建一个 Elasticsearch 集群文章所述，elasticsearch集群中节点有多种类型：

```
主节点：即 Master 节点。主节点的主要职责是和集群操作相关的内容，如创建或删除索引，跟踪哪些节点是群集的一部分，并决定哪些分片分配给相关的节点。稳定的主节点对集群的健康是非常重要的。默认情况下任何一个集群中的节点都有可能被选为主节点。索引数据和搜索查询等操作会占用大量的cpu，内存，io资源，为了确保一个集群的稳定，分离主节点和数据节点是一个比较好的选择。虽然主节点也可以协调节点，路由搜索和从客户端新增数据到数据节点，但最好不要使用这些专用的主节点。一个重要的原则是，尽可能做尽量少的工作。

数据节点：即 Data 节点。数据节点主要是存储索引数据的节点，主要对文档进行增删改查操作，聚合操作等。数据节点对 CPU、内存、IO 要求较高，在优化的时候需要监控数据节点的状态，当资源不够的时候，需要在集群中添加新的节点。

负载均衡节点：也称作 Client 节点，也称作客户端节点。当一个节点既不配置为主节点，也不配置为数据节点时，该节点只能处理路由请求，处理搜索，分发索引操作等，从本质上来说该客户节点表现为智能负载平衡器。独立的客户端节点在一个比较大的集群中是非常有用的，他协调主节点和数据节点，客户端节点加入集群可以得到集群的状态，根据集群的状态可以直接路由请求。

预处理节点：也称作 Ingest 节点，在索引数据之前可以先对数据做预处理操作，所有节点其实默认都是支持 Ingest 操作的，也可以专门将某个节点配置为 Ingest 节点。

以上就是节点几种类型，一个节点其实可以对应不同的类型，如一个节点可以同时成为主节点和数据节点和预处理节点，但如果一个节点既不是主节点也不是数据节点，那么它就是负载均衡节点。具体的类型可以通过具体的配置文件来设置。
```
