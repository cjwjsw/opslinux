# 一、提示无权限

```
ll /var/spool/

drwx------.  2 root  root  4096 May 20 11:33 cron
```

# 二、解决办法
```
chmod 755  /var/spool/cron

chmod 644  /var/spool/cron/root
```
