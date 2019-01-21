# 设置删除binlog日志
```
1.重启mysql,开启mysql主从，设置expire_logs_days

# vim /etc/my.cnf //修改expire_logs_days,x是自动删除的天数，一般将x设置为短点，如10
expire_logs_days = x //二进制日志自动删除的天数。默认值为0,表示“没有自动删除”

此方法需要重启mysql，附录有关于expire_logs_days的英文说明
```

# 二、不重启mysql方法

```
当然也可以不重启mysql,开启mysql主从，直接在mysql里设置expire_logs_days
> show binary logs;
> show variables like '%log%';
> set global expire_logs_days = 10;
```
