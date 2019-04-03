# 一、软件包下载
```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.0.tar.gz
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.7.0-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.7.0-linux-x86_64.tar.gz
```
# 二、配置Elasticsearch实现冷热数据分离
为了不浪费服务器资源（每台机器上均配置有SSD和大存储,且内存配置较高），提高ES读写性能，我们尝试进行了ES集群冷热分离的配置。四台机器，均配置有SSD和SATA盘。每台机器上运行两个ES实例，其中一个实例为配置data目录为SSD

master节点：普通服务器即可(CPU 内存 消耗一般)；

data节点：主要消耗磁盘，内存；

client节点：普通服务器即可(如果要进行分组聚合操作的话，建议这个节点内存也分配多一点)。

  ![elasticsearch冷热架构](https://github.com/Lancger/opslinux/blob/master/images/es-hot-cold.png)

```
ssd 热数据
sata 冷数据
```
# 三、准备Elasticsearch

1、安装Java环境
```
#yum安装
yum -y install java-1.8.0-openjdk

#源码安装
java   http://www.oracle.com/technetwork/java/javase/downloads/index.html 

tar -zxvf jdk-8u201-linux-x64.tar.gz -C /opt/

#Set JAVA_HOME
export JAVA_HOME=/opt/jdk1.8.0_201
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

使环境变量生效
source /etc/profile

验证安装是否成功
java -version
```


2、新增用户和系统配置
```
1、新增用户和解压安装包
chattr -i /etc/passwd* && chattr -i /etc/group* && chattr -i /etc/shadow* && chattr -i /etc/gshadow*
useradd elk
mkdir -p /usr/local/elk/
su elk

tar -zxvf elasticsearch-6.7.0.tar.gz -C /usr/local/elk
chown -R elk:elk /usr/local/elk/

2、增加vm.max_map_count项到sysctl.conf文件中
a、修改配置文件方式
vim /etc/sysctl.conf
vm.max_map_count = 655360
sysctl -p

b、命令行方式
sysctl -w vm.max_map_count=655360
sysctl -a | grep vm.max_map_count

3、修改用户文件最大数量
vim /etc/security/limits.conf 
elk        hard    nofile           262144
elk        soft    nofile           262144
```

3、修改配置文件
```
创建热数据存放目录
mkdir -p /data/database/elasticsearch/ /data1/database/elasticsearch/

创建冷数据存放目录
mkdir -p /data/database/elasticsearch-cold/ /data1/database/elasticsearch-cold/
```
热数据节点配置
```
cat << EOF > /usr/local/elk/elasticsearch-6.7.0/config/elasticsearch.yml
cluster.name: Demo-Cloud  #配置集群名称
node.name: node-1  #配置节点名称
node.attr.box_type: hot  #node.attr.box_type: hot热数据节点，node.attr.box_type: cold 冷数据节点
node.max_local_storage_nodes: 2  #允许每个机器启动两个es进程
node.master: true  #指定该节点是否有资格被选举成为node，默认是true，es是默认集群中的第一台机器为master，如果这台机挂了就会重新选举master。
node.data: true  #指定该节点是否存储索引数据，默认为true。
index.number_of_shards: 5  #设置默认索引分片个数，默认为5片。
index.number_of_replicas: 1  #设置默认索引副本个数，默认为1个副本。
path.data: /data/database/elasticsearch/,/data1/database/elasticsearch/  #配置data存放的路径，磁盘为ssd磁盘
path.logs: /usr/local/elk/elasticsearch-6.7.0/logs  #配置日志存放的路径
bootstrap.memory_lock: false  #配置是否使用内存交换分区
bootstrap.system_call_filter: false  #配置是否启用检测
http.max_content_length: 1000mb  #设置内容的最大容量，默认100mb
http.enabled: false  #是否使用http协议对外提供服务，默认为true，开启。
gateway.type: local  #gateway的类型，默认为local即为本地文件系统，可以设置为本地文件系统，分布式文件系统，hadoop的HDFS，和amazon的s3服务器等。
gateway.recover_after_nodes: 1  #设置集群中N个节点启动时进行数据恢复，默认为1。
network.host: 0.0.0.0  #配置监听地址
http.port: 9200  #配置监听端口
transport.tcp.port: 9300  #设置节点之间交互的tcp端口，默认是9300。
discovery.zen.ping.timeout: 3s  #设置集群中自动发现其它节点时ping连接超时时间，默认为3秒，对于比较差的网络环境可以高点的值来防止自动发现时出错。
discovery.zen.ping.multicast.enabled: false  #配置是否启用广播地址
discovery.zen.ping.unicast.hosts: ["tw13c912:9300", "tw13c912:9301", "tw13c916:9300", "tw13c916:9301", "tw13c917:9300", "tw13c917:9301"]  #配置指定节点
EOF
```
冷数据节点配置
```
cat << EOF > /usr/local/elk/elasticsearch-6.7.0/config/elasticsearch.yml
cluster.name: Demo-Cloud  #配置集群名称
node.name: node-1  #配置节点名称
node.attr.box_type: hot  #node.attr.box_type: hot热数据节点，node.attr.box_type: cold 冷数据节点
node.max_local_storage_nodes: 2  #允许每个机器启动两个es进程
node.master: true  #指定该节点是否有资格被选举成为node，默认是true，es是默认集群中的第一台机器为master，如果这台机挂了就会重新选举master。
node.data: true  #指定该节点是否存储索引数据，默认为true。
index.number_of_shards: 5  #设置默认索引分片个数，默认为5片。
index.number_of_replicas: 1  #设置默认索引副本个数，默认为1个副本。
path.data: /data/database/elasticsearch/,/data1/database/elasticsearch/  #配置data存放的路径，磁盘为ssd磁盘
path.logs: /usr/local/elk/elasticsearch-6.7.0/logs  #配置日志存放的路径
bootstrap.memory_lock: false  #配置是否使用内存交换分区
bootstrap.system_call_filter: false  #配置是否启用检测
http.max_content_length: 1000mb  #设置内容的最大容量，默认100mb
http.enabled: false  #是否使用http协议对外提供服务，默认为true，开启。
gateway.type: local  #gateway的类型，默认为local即为本地文件系统，可以设置为本地文件系统，分布式文件系统，hadoop的HDFS，和amazon的s3服务器等。
gateway.recover_after_nodes: 1  #设置集群中N个节点启动时进行数据恢复，默认为1。
network.host: 0.0.0.0  #配置监听地址
http.port: 9200  #配置监听端口
transport.tcp.port: 9300  #设置节点之间交互的tcp端口，默认是9300。
discovery.zen.ping.timeout: 3s  #设置集群中自动发现其它节点时ping连接超时时间，默认为3秒，对于比较差的网络环境可以高点的值来防止自动发现时出错。
discovery.zen.ping.multicast.enabled: false  #配置是否启用广播地址
discovery.zen.ping.unicast.hosts: ["tw13c912:9300", "tw13c912:9301", "tw13c916:9300", "tw13c916:9301", "tw13c917:9300", "tw13c917:9301"]  #配置指定节点
EOF
```

# 三、准备Filebeat


参考文档

elk       https://www.elastic.co/cn/products 

http://www.mamicode.com/info-detail-2361555.html    elasticsearch实现冷热数据分离

