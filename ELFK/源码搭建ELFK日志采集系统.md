# 一、软件包下载
```
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.7.0.tar.gz
wget https://artifacts.elastic.co/downloads/kibana/kibana-6.7.0-linux-x86_64.tar.gz
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-6.7.0-linux-x86_64.tar.gz
```

# 二、准备Elasticsearch

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
mv elasticsearch-6.7.0 elasticsearch
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
cat << EOF > /etc/elasticsearch/elasticsearch.yml
cluster.name: DemoESCluster
# 注意不同节点的node.name要设置得不一样
node.name: demo-es-node-1
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
network.host: 0.0.0.0
http.port: 9200
discovery.zen.ping.unicast.hosts: ["10.211.55.11", "10.211.55.12", "10.211.55.13"]
discovery.zen.minimum_master_nodes: 2
gateway.recover_after_nodes: 2
EOF
```

# 三、准备Filebeat


参考文档

elk       https://www.elastic.co/cn/products 
