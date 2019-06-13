#!/bin/bash

#安装zabbix4.0_proxy脚本

err_echo(){
    echo -e "\033[41;37m[Error]: $1 \033[0m"
    exit 1
}

info_echo(){
    echo -e "\033[42;37m[Info]: $1 \033[0m"
}

check_file_is_exists(){
    if [ ! -f "/usr/local/src/$1" ];then
        info_echo "$1开始下载"
    fi
}

check_exit(){
    if [ $? -ne 0 ]; then
        err_echo "$1"
        exit 1
    fi
}

check_success(){
    if [ $? -eq 0 ];then
        info_echo "$1"
    fi
}

zabbix_server_version="4.0.9"

[ $(id -u) != "0" ] && err_echo "please run this script as root user." && exit 1

function init_servers(){

    info_echo "开始初始化服务器"
    sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
    setenforce 0
    systemctl stop firewalld.service
    systemctl disable firewalld.service
    
    info_echo "更换阿里源"
    yum install wget -y
    cp /etc/yum.repos.d/* /tmp
    rm -f /etc/yum.repos.d/*
    wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
    yum clean all
    yum makecache

}

function install_package(){

    info_echo "开始安装系统必备依赖包"
    yum install -y ntpdate gcc gcc-c++ wget lsof lrzsz mysql-devel curl-devel

}

function download_install_package(){
    
    if [ ! -f "/usr/local/src/zabbix-${zabbix_server_version}.tar.gz" ];then
        info_echo "开始下载zabbix-${zabbix_server_version}.tar.gz"
        wget -O /usr/local/src/zabbix-${zabbix_server_version}.tar.gz https://sourceforge.net/projects/zabbix/files/ZABBIX%20Latest%20Stable/${zabbix_server_version}/zabbix-${zabbix_server_version}.tar.gz
        check_success "zabbix-${zabbix_server_version}.tar.gz已下载至/usr/local/src目录"
    else
        info_echo "zabbix-${zabbix_server_version}.tar.gz已存在,不需要下载"
    fi

}

function install_mysql(){
     
    info_echo "开始安装mysql"
    sleep 2s
    yum install mariadb-server -y
    check_exit "安装mysql失败"
    systemctl start mariadb
    STAT=`echo $?`
    PORT=`netstat -lntup|grep mysql|wc -l`
    if [ $STAT -eq 0 ] && [ $PORT -eq 1 ];then
        info_echo "mysql启动成功"
    else
        err_echo "mysql未启动成功,请检查"
    fi
    
    info_echo "开始创建zabbix账号和授权"
    sleep 2s
    mysql -uroot -e "create database zabbix_proxy character set utf8;" 
    mysql -uroot -e "grant all privileges on zabbix_proxy.* to zabbix@localhost identified by 'zabbix';"
    mysql -uroot -e "flush privileges;"
    mysql -uroot -e "show databases;"
    
}

function install_zabbix(){

    info_echo "开始安装zabbix-${zabbix_server_version}-proxy"
    groupadd zabbix &&  useradd -g zabbix zabbix
    sleep 2s
    yum install OpenIPMI-devel libevent-devel net-snmp-devel -y
    cd /usr/local/src/ && tar xvf zabbix-${zabbix_server_version}.tar.gz
    cd /usr/local/src/zabbix-${zabbix_server_version}
    ./configure \
    --prefix=/usr/local/zabbix_proxy \
    --enable-proxy --enable-agent \
    --with-mysql --with-net-snmp \
    --with-libcurl 
    check_exit "configure zabbix-${zabbix_server_version}-proxy失败"
    make && make install
    check_exit "make zabbix-${zabbix_server_version}-proxy失败"
    info_echo "开始配置zabbix-${zabbix_server_version}-proxy"

cat <<"EOF" > /usr/local/zabbix_proxy/etc/zabbix_proxy.conf
ProxyMode=0   #指定代理那种模式的agent，0为主动模式，1位被动模式；
Server=192.168.56.12 #zabbix server服务器的地址或主机名
ServerPort=10051
Hostname=zbx_pxy_01  #代理服务器的名称
DBHost=localhost
DBName=zabbix_proxy
DBUser=zabbix
DBPassword=zabbix
DebugLevel=4
ConfigFrequency=10  #间隔多久从zabbix server获取监控信息
DataSenderFrequency=5  #数据发送时间间隔，默认为1秒，被动模式不使用
StartPollers=10
StartPollersUnreachable=5
StartTrappers=20
StartPingers=20
StartDiscoverers=20
HousekeepingFrequency=1
CacheSize=128M
StartDBSyncers=10
HistoryCacheSize=128M
HistoryTextCacheSize=64M
#FpingLocation=/usr/sbin/fping
LogSlowQueries=3000
LogFile=/var/logs/zabbix_proxy.log
EOF

    info_echo "开始导入mysql数据"
    mysql -uzabbix -pzabbix zabbix < /usr/local/src/zabbix-${zabbix_server_version}/database/mysql/schema.sql 

    info_echo "开始启动zabbix_proxy"
    sleep 2s
    /usr/local/zabbix_proxy/sbin/zabbix_proxy
    STAT=`echo $?`
    PORT=`netstat -lntup|grep zabbix_proxy|wc -l`
    if [ $STAT -eq 0 ] && [ $PORT -eq 1 ];then
        info_echo "zabbix_proxy启动成功"
    else
        err_echo "zabbix_proxy,请检查"
    fi
}

function main(){

    init_servers
    install_package
    download_install_package
    install_mysql
    install_zabbix
    
}

main
