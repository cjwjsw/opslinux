```
rsync -avzP --exclude="log" --exclude="logs" --exclude="2019-05*" /data0/opt/tomcat8_8085_openapi root@192.168.52.110:/data0/opt/

rsync -avzP /usr/local/apache-activemq-5.15.8 root@23.244.63.94:/usr/local/


rsync -av /opt/ root@192.168.52.130:/opt/
rsync -avzP --exclude="log" --exclude="logs" --exclude="2019-05*" /data0/opt/ root@192.168.52.130:/data0/opt/
```
