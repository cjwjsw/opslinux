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
        <td><strong>手动部署</strong></td>
        <td><a >1.Kubernetes集群环境准备</a></td>
        <td><a >2.Docker安装</a></td>
        <td><a 3.CA证书制作</a></td>
        <td><a stall.md">4.ETCD集群部署</a></td>
        <td><a md">5.Master节点部署</a></td>
        <td><a ">6.Node节点部署</a></td>
        <td><a .md">7.Flannel部署</a></td>
        <td><a >8.应用创建</a></td>
    </tr>
    <tr>
        <td><strong>必备插件</strong></td>
        <td><a href="docs/coredns.md">1.CoreDNS部署</a></td>
        <td><a href="docs/dashboard.md">2.Dashboard部署</a></td>
        <td><a href="docs/heapster.md">3.Heapster部署</a></td>
        <td><a href="docs/ingress.md">4.Ingress部署</a></td>
        <td><a href="https://github.com/unixhot/devops-x">5.CI/CD</a></td>
        <td><a href="docs/helm.md">6.Helm部署</a></td>
        <td><a href="docs/helm.md">6.Helm部署</a></td>
    </tr>
</table>

服务器host11 	服务器host12 	服务器host13
elasticsearch(master,data,client) 	elasticsearch(master,data,client) 	elasticsearch(master,data,client)
	kibana 	
logstash 	logstash 	logstash
filebeat 	filebeat 	filebeat
