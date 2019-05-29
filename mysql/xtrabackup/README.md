# 一、yum和rpm安装
```
#1、Installing Percona XtraBackup from Percona yum repository

yum install https://repo.percona.com/yum/percona-release-latest.noarch.rpm

yum install percona-xtrabackup-80

#2、Installing Percona XtraBackup using downloaded rpm packages

wget https://www.percona.com/downloads/XtraBackup/Percona-XtraBackup-8.0.4/binary/redhat/7/x86_64/percona-xtrabackup-80-8.0.4-1.el7.x86_64.rpm
yum localinstall percona-xtrabackup-80-8.0.4-1.el7.x86_64.rpm

```
# 二、主库导出数据
```
#全库导出
innobackupex --default-file=/etc/my.cnf --user=root --password=***** --stream=tar  --tmpdir=/usr/local/mysql_bk/ /usr/local/mysql_bk/  |pigz -p 16 |ssh -i /root/.ssh/id_rsa_new root@192.168.56.100 "pigz -d | tar -xf - -C /data1/mysql"

#指定数据库导出
innobackupex --default-file=/etc/my.cnf --user=root --password=***** --databases=user_storage --stream=tar  --tmpdir=/usr/local/mysql_bk/ /usr/local/mysql_bk/  |pigz -p 16 |ssh -i /root/.ssh/id_rsa_new root@192.168.56.100 "pigz -d | tar -xf - -C /data1/mysql"
```

# 三、从库恢复

```
#查看binlog日志
[root@ mysql]# cat /data1/mysql/xtrabackup_binlog_info
mysql-bin.000002 499886662


#恢复数据
innobackupex --default-file=/etc/my.cnf --apply-log /data1/mysql/
```


参考文档：

https://www.percona.com/doc/percona-xtrabackup/8.0/installation/yum_repo.html  Installing Percona XtraBackup on Red Hat Enterprise Linux and CentOS
