# 一、安装
```
yum install -y daemonize
chattr -i /etc/passwd* && chattr -i /etc/group* && chattr -i /etc/shadow*
groupadd prometheus
useradd -g prometheus prometheus -s /sbin/nologin -c "prometheus Daemons"
chattr +i /etc/passwd* && chattr +i /etc/group* && chattr +i /etc/shadow*
mkdir -p /usr/local/prometheus/mysql_exporter/
cd /usr/local/src/
wget -O /usr/local/src/mysqld_exporter-0.11.0.linux-amd64.tar.gz https://github.com/prometheus/mysqld_exporter/releases/download/v0.11.0/mysqld_exporter-0.11.0.linux-amd64.tar.gz
tar -xvf mysqld_exporter-0.11.0.linux-amd64.tar.gz
mv mysqld_exporter-0.11.0.linux-amd64/* /usr/local/prometheus/mysql_exporter/
chown -R prometheus:prometheus /usr/local/prometheus/
mkdir -p /var/run/prometheus/
mkdir -p /var/log/prometheus/
chown prometheus:prometheus /var/run/prometheus/
chown prometheus:prometheus /var/log/prometheus/
touch /var/log/prometheus/mysql_exporter.log
chmod 777 /var/log/prometheus/mysql_exporter.log
chown prometheus:prometheus /var/log/prometheus/mysql_exporter.log
touch /etc/sysconfig/mysql_exporter.conf
cat > /etc/sysconfig/mysql_exporter.conf <<\EOF
ARGS=""
EOF
chmod +x /etc/init.d/mysql_exporter
/etc/init.d/mysql_exporter start
chkconfig mysql_exporter on
```

# 二、启动脚本
```
cat > /etc/init.d/mysql_exporter <<\EOF
#!/bin/bash
#
# /etc/rc.d/init.d/mysql_exporter
#
# chkconfig: 2345 80 80
#
# config: /etc/prometheus/mysql_exporter.conf
# pidfile: /var/run/prometheus/mysql_exporter.pid

# Source function library.
. /etc/init.d/functions

RETVAL=0
PROG="mysql_exporter"
DAEMON_SYSCONFIG=/etc/sysconfig/${PROG}.conf
DAEMON=/usr/local/prometheus/mysql_exporter/${PROG}
PID_FILE=/var/run/prometheus/${PROG}.pid
LOCK_FILE=/var/lock/subsys/${PROG}
LOG_FILE=/var/log/prometheus/mysql_exporter.log
DAEMON_USER="prometheus"
GOMAXPROCS=$(grep -c ^processor /proc/cpuinfo)

. ${DAEMON_SYSCONFIG}

start() {
  if check_status > /dev/null; then
    echo "mysql_exporter is already running"
    exit 0
  fi

  echo -n $"Starting mysql_exporter: "
  daemonize -u ${DAEMON_USER} -p ${PID_FILE} -l ${LOCK_FILE} -a -e ${LOG_FILE} -o ${LOG_FILE} ${DAEMON} ${ARGS} && success || failure

  RETVAL=$?
  echo ""
  return $RETVAL
}

stop() {
    echo -n $"Stopping mysql_exporter: "
    killproc -p ${PID_FILE} -d 10 ${DAEMON}
    RETVAL=$?
    echo
    [ $RETVAL = 0 ] && rm -f ${LOCK_FILE} ${PID_FILE}
    return $RETVAL
}

check_status() {
    status -p ${PID_FILE} ${DAEMON}
    RETVAL=$?
    return $RETVAL
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
    check_status
        ;;
    reload|force-reload)
        reload
        ;;
    restart)
        stop
        start
        ;;
    *)
        N=/etc/init.d/${NAME}
        echo "Usage: $N {start|stop|status|restart|force-reload}" >&2
        RETVAL=2
        ;;
esac

exit ${RETVAL}
EOF
```

# 三、设置开机启动
```
chmod +x /etc/init.d/mysql_exporter

chkconfig mysql_exporter on
```
参考文档：

https://www.veryarm.com/19670.html  
