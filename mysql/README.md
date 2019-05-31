## 一、mysql手册
- [Centos6安装mysql5.6](https://github.com/Lancger/opslinux/blob/master/mysql/install/mysql5.6/centos6-one-install.md)

- [Centos6安装mysql5.7](https://github.com/Lancger/opslinux/blob/master/mysql/install/mysql5.7/Yum方式安装MySQL5.7.md)

- [Centos7安装mysql5.6](https://github.com/Lancger/opslinux/blob/master/mysql/install/mysql5.6/centos7-one-install.md)

- [Centos7安装mysql5.7](https://github.com/Lancger/opslinux/blob/master/mysql/install/mysql5.7/Yum方式安装MySQL5.7.md)

- [Mysql主从架构](https://github.com/Lancger/opslinux/blob/master/mysql/mysql%E4%B8%BB%E4%BB%8E%E6%9E%B6%E6%9E%84.md)

- [Mysql-MHA原理和部署](https://github.com/Lancger/opslinux/blob/master/mysql/Mysql-MHA.md)

- [Mysql架构分享和调优](https://github.com/Lancger/opslinux/blob/master/mysql/MYSQL企业常用架构与调优经验分享.md)



## 二、修改密码
```
#方式一
/usr/bin/mysqladmin -u root password '123456'

#方式二
mysql> set password=password('123456');

#方式三
mysql> use mysql
mysql> GRANT ALL PRIVILEGES ON *.* TO root@"%" IDENTIFIED BY "root";
mysql> update user set Password = password('123456') where User='root';
mysql> show grants for root@"%";
mysql> flush privileges;
mysql> select Host,User,Password from user where User='root';
mysql> exit
```

## 三、查看表结构和新建库
```
mysql> desc user;

mysql> show create table user\G;

mysql> describe user;

mysql -h 127.0.0.1 -u root -p123456 -e "create database cmdb default character set utf8mb4 collate utf8mb4_unicode_ci;"
```

## 四、查看参数变量
```
mysql> show variables like 'log_error';
+---------------+---------------------+
| Variable_name | Value               |
+---------------+---------------------+
| log_error     | /var/log/mysqld.log |
+---------------+---------------------+
1 row in set (0.01 sec)

mysql> show variables like '%slow%';
+---------------------------+--------------------------+
| Variable_name             | Value                    |
+---------------------------+--------------------------+
| log_slow_admin_statements | OFF                      |
| log_slow_slave_statements | OFF                      |
| slow_launch_time          | 2                        |
| slow_query_log            | ON                       |
| slow_query_log_file       | /var/log/mysqld-slow.log |
+---------------------------+--------------------------+
5 rows in set (0.00 sec)
```
## 五、模拟产生慢日志
```
mysql> show variables like '%quer%';
+----------------------------------------+--------------------------+
| Variable_name                          | Value                    |
+----------------------------------------+--------------------------+
| binlog_rows_query_log_events           | OFF                      |
| ft_query_expansion_limit               | 20                       |
| have_query_cache                       | YES                      |
| log_queries_not_using_indexes          | OFF                      |
| log_throttle_queries_not_using_indexes | 0                        |
| long_query_time                        | 3.000000                 |    --这里设置的超过3秒会记录到慢查询日志
| query_alloc_block_size                 | 8192                     |
| query_cache_limit                      | 1048576                  |
| query_cache_min_res_unit               | 4096                     |
| query_cache_size                       | 1048576                  |
| query_cache_type                       | OFF                      |
| query_cache_wlock_invalidate           | OFF                      |
| query_prealloc_size                    | 8192                     |
| slow_query_log                         | ON                       |    --开启了慢日志查询
| slow_query_log_file                    | /var/log/mysqld-slow.log |    --慢日志文件
+----------------------------------------+--------------------------+
15 rows in set (0.00 sec)

mysql> select sleep(3) as a, 1 as b;    --模拟产生慢日志
+---+---+
| a | b |
+---+---+
| 0 | 1 |
+---+---+
1 row in set (10.00 sec)

#查看慢日志
[root@master log]# cat mysqld-slow.log
/usr/sbin/mysqld, Version: 5.6.41-log (MySQL Community Server (GPL)). started with:
Tcp port: 3306  Unix socket: /var/lib/mysql/mysql.sock
Time                 Id Command    Argument
# Time: 181010 18:52:05
# User@Host: root[root] @ localhost []  Id:     2
# Query_time: 2.001668  Lock_time: 0.000000 Rows_sent: 1  Rows_examined: 0
SET timestamp=1539168725;
select sleep(2) as a, 1 as b;
```

## 六、只安装mysql-client
```
# centos6
rpm -ivh http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
yum install -y mysql-client

# centos7
rpm -ivh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
yum install -y mysql-community-client
```

## 七、修改mysql引擎
```
default-storage-engine = InnoDB

alter table password ENGINE = InnoDB;

alter table password modify column sn varchar(50);

mysql> show variables like "%default%";
+---------------------------------+--------+
| Variable_name                   | Value  |
+---------------------------------+--------+
| default_storage_engine          | InnoDB |
| default_tmp_storage_engine      | InnoDB |
| default_week_format             | 0      |
| explicit_defaults_for_timestamp | OFF    |
+---------------------------------+--------+
4 rows in set (0.00 sec)

```

## 八、查询用户
```
mysql> use mysql;
mysql> select Host,User from user;
+--------------+---------------+
| Host         | User          |
+--------------+---------------+
| %            | root          |
| 192.168.52.% | exchange      |
| 192.168.52.% | root          |
| localhost    | mysql.session |
| localhost    | mysql.sys     |
| localhost    | root          |
+--------------+---------------+


show grants for exchange@"192.168.52.%";
show grants for exchange@"%";


#msyql不能执行存储过程解决办法
GRANT ALL PRIVILEGES ON *.* TO exchange@"%" IDENTIFIED BY "qaA12!@$#$";
GRANT ALL PRIVILEGES ON *.* TO 'exchange'@'%';
GRANT EXECUTE ON `ichson_lore_source`.* TO 'exchange'@'%';
GRANT SELECT ON `mysql`.`proc` TO 'exchange'@'%';

```

## 九、mysql从库设置只读
```
mysql> set global read_only = 1;
Query OK, 0 rows affected (0.00 sec)

mysql> show variables like '%read_only%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| innodb_read_only | OFF   |
| read_only        | ON    |
| tx_read_only     | OFF   |
+------------------+-------+
3 rows in set (0.00 sec)

```
