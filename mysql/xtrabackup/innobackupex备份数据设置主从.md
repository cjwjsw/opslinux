# 一、操作记录
```
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm

yum install -y percona-xtrabackup-24

innobackupex --default-file=/etc/my.cnf --user=root --password=123456 --stream=tar  --tmpdir=/usr/local/mysql_bk/ /usr/local/mysql_bk/  |pigz -p 16 |ssh root@192.168.52.132 "pigz -d | tar -xf - -C /data0/mysql_data"

innobackupex --default-file=/etc/my.cnf --apply-log /data0/mysql_data

chown -R mysql:mysql /data0/mysql_data

systemctl restart mysqld

mysql -uroot -p'123456'

use aud2;

select count('id') from test_while;
```
