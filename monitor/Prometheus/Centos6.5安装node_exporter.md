# 一、安装
```
chattr -i /etc/passwd* && chattr -i /etc/group* && chattr -i /etc/shadow*
groupadd prometheus
useradd -g prometheus prometheus -s /sbin/nologin -c "prometheus Daemons"
cd /usr/local/src/
mkdir -p /usr/local/prometheus/node_exporter/
wget -O /usr/local/src/node_exporter-0.17.0.linux-amd64.tar.gz https://github.com/prometheus/node_exporter/releases/download/v0.17.0/node_exporter-0.17.0.linux-amd64.tar.gz
tar -xvf node_exporter-0.17.0.linux-amd64.tar.gz
mv node_exporter-0.17.0.linux-amd64/* /usr/local/prometheus/node_exporter/
chown -R prometheus:prometheus /usr/local/prometheus/
mkdir -p /var/run/prometheus/
mkdir -p /var/log/prometheus/
chown prometheus:prometheus /var/run/prometheus/
chown prometheus:prometheus /var/log/prometheus/
touch /var/log/prometheus/node_exporter.log
chmod 777 /var/log/prometheus/node_exporter.log
chown prometheus:prometheus /var/log/prometheus/node_exporter.log
touch /etc/sysconfig/node_exporter.conf
cat > /etc/sysconfig/node_exporter.conf <<EOF
ARGS=""
EOF
/etc/init.d/node_exporter start
chkconfig node_exporter on
```

# 二、启动脚本
```
cat > /etc/init.d/node_exporter <<EOF
#!/bin/bash
#
#   /etc/rc.d/init.d/node_exporter
#
# chkconfig: 2345 80 80
#
# config: /etc/prometheus/node_exporter.conf
# pidfile: /var/run/prometheus/node_exporter.pid

# Source function library.
. /etc/init.d/functions


RETVAL=0
PROG="node_exporter"
DAEMON_SYSCONFIG=/etc/sysconfig/${PROG}.conf
DAEMON=/usr/local/prometheus/node_exporter/${PROG}
PID_FILE=/var/run/prometheus/${PROG}.pid
LOCK_FILE=/var/lock/subsys/${PROG}
LOG_FILE=/var/log/prometheus/node_exporter.log
DAEMON_USER="prometheus"
GOMAXPROCS=$(grep -c ^processor /proc/cpuinfo)

. ${DAEMON_SYSCONFIG}

start() {
  if check_status > /dev/null; then
    echo "node_exporter is already running"
    exit 0
  fi

  echo -n $"Starting node_exporter: "
  daemonize -u ${DAEMON_USER} -p ${PID_FILE} -l ${LOCK_FILE} -a -e ${LOG_FILE} -o ${LOG_FILE} ${DAEMON} ${ARGS}
  RETVAL=$?
  echo ""
  return $RETVAL
}

stop() {
    echo -n $"Stopping node_exporter: "
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
chkconfig node_exporter on
```
参考文档：

https://www.veryarm.com/19670.html  
