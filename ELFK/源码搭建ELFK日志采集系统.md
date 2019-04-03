
# 一、准备Elasticsearch

1、安装Java环境
```
#yum安装
yum -y install java-1.8.0-openjdk

#源码安装
java   http://www.oracle.com/technetwork/java/javase/downloads/index.html 

export JAVA_HOME=/opt/jdk1.8.0_181
export PATH=$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

使环境变量生效
source /etc/bashrc

验证安装是否成功
java -version
```


2、编写Elasticearch的yum仓库文件


参考文档

elk       https://www.elastic.co/cn/products 
