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
        <td><a >elasticsearch(master,data,client)</a></td>
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
