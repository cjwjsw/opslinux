# 一、java环境部署

```
wget https://download.oracle.com/otn/java/jdk/8u211-b12/478a62b7d4e34b78b671c754eaaf38ab/jdk-8u211-linux-x64.tar.gz

mkdir /opt/java && cd /opt/java 
tar -zxvf jdk-8u211-linux-x64.tar.gz

vim /etc/profile
在最后一行添加
#java environment
export JAVA_HOME=/root/jdk1.8.0_201
export CLASSPATH=.:${JAVA_HOME}/jre/lib/rt.jar:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar
export PATH=$PATH:${JAVA_HOME}/bin

source /etc/profile  (生效环境变量)

java -version       (检查安装 是否成功)
```

