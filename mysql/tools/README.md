# 一、表数据一致性校验
```
pt-table-checksum --replicate=percona.checksums --host=192.168.56.12 --user=root --password=123456 --nocheck-binlog-format --nocheck-plan --nocheck-replication-filters --recursion-method=dsn=D=percona,t=dsns
```

# 二、表结构和数据同步
```
pt-table-sync --sync-to-master h=192.168.56.12,P=3306,u=root,p=123456 --databases=center --charset=utf8 --print  > diff.sql
```