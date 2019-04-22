# 一、JAVA环境部署

```
#1、yum安装
yum -y install java-1.8.0-openjdk


#2、源码安装
wget https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.tar.gz

mkdir /opt/java && cd /opt/java 
tar -zxvf jdk-8u211-linux-x64.tar.gz

vim /etc/profile
#在最后一行添加
#java environment
export JAVA_HOME=/opt/java/jdk1.8.0_211
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=$PATH:${JAVA_HOME}/bin

source /etc/profile  (生效环境变量)

java -version       (检查安装 是否成功)
```

# 二、Activemq安装部署
```
http://activemq.apache.org/download.html  

wget http://archive.apache.org/dist/activemq/5.15.8/apache-activemq-5.15.8-bin.tar.gz
tar -zxvf apache-activemq-5.15.8-bin.tar.gz

vim  apache-activemq-5.15.8/conf/activemq.xml (开启jmx,默认为false)

./apache-activemq-5.15.8/bin/activemq start (启动MQ)
```

