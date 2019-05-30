#!/bin/bash
#Date: 2018-07-03
#Author: Lancger
#Mai: 1151980610@qq.com
#Function:  This script is used for system Centos6 or Centos7 initialization 
#Version:  V1.0
#Update:  2018-07-03

. /etc/init.d/functions

if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root ." >&2
    exit 1
fi

echo -e "\033[31m 这个是centos6/7系统初始化脚本，请慎重运行！Please continue to enter or ctrl+C to cancel \033[0m"
sleep 3

# get kernel version
RELEASEVER=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

#configure yum source
yum_config(){
    if [ $RELEASEVER == 6 ];then
        echo -e "\033[32m 这个是Centos6系统 \033[0m"
        mv -f /etc/yum.repos.d /etc/yum.repos.d_backup
        mkdir /etc/yum.repos.d
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS6-Base-163.repo
    fi
    if [ $RELEASEVER == 7 ];then
        echo -e "\033[32m 这个是Centos7系统 \033[0m"
        mv -f /etc/yum.repos.d /etc/yum.repos.d_backup
        mkdir /etc/yum.repos.d
        wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
    fi
    yum clean all
    yum makecache
    yum -y install vim wget telnet bind-utils epel-release rsync bc lsof traceroute strace net-snmp lrzsz zip xz unzip vnstat iotop iftop bc net-tools openssh-clients gcc gcc-c++ make cmake libxml2-devel openssl-devel curl curl-devel sudo ntp ntpdate ncurses-devel autoconf automake zlib-devel python-devel iptables-services iptables
}

#firewalld
iptables_config(){
    if [ $RELEASEVER == 6 ];then
        /etc/init.d/iptables save
        /etc/init.d/iptables stop
        chkconfig iptables off
        iptables -P INPUT ACCEPT
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -Z
    fi
    if [ $RELEASEVER == 7 ];then
        service iptables save
        systemctl stop firewalld.service
        systemctl disable firewalld.service
        iptables -P INPUT ACCEPT
        /sbin/iptables -F
        /sbin/iptables -X
        /sbin/iptables -Z
    fi
}

system_bash(){
    #修改Bash提示符字符串
    echo "改Bash提示符字符串......"
    echo 'PS1="\[\e[37;40m\][\[\e[32;40m\]\u\[\e[37;40m\]@\h \[\e[36;40m\]\w\[\e[0m\]]\\$ "' >> ~/.bashrc
    source ~/.bashrc
}

#system config
system_config(){
    sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
    setenforce 0

    # 设置上海时区
    # cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

    # 设置为东京时区
    # ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
}

#set ulimit
ulimit_config(){

    tag1=`grep  "ulimit -SHn" /etc/rc.local`

    if [ $? -eq 0 ]
    then
        echo "参数存在替换"
        sed -i 's/^ulimit -SHn.*/ulimit -SHn 65535/g' /etc/rc.local
        # sed -i "/^ulimit -SHn/c ulimit -SHn 102400" /etc/rc.local    # c 匹配行替换
    else
        echo "ulimit -SHn 204800" >> /etc/rc.local
    fi

    echo "limit memory"
    mem=`free |sed -n '2p'|awk '{print $2}'`
    rem=`echo "$mem * 0.8"|bc|awk '{print int($0)}'`
    echo $rem
    tag2=`grep  "ulimit -m" /etc/profile`
    if [ $? -eq 0 ]
    then
        echo "内存限制参数存在替换"
        sed -i 's/^ulimit -m.*/ulimit -m '"$rem"'/g' /etc/profile
    else
        echo "ulimit -m $rem" >> /etc/profile
    fi

    sed -i "/^ulimit -SHn.*/d" /etc/profile
    echo "ulimit -SHn 204800" >> /etc/profile

    mv /etc/security/limits.conf /etc/security/limits.conf-default_bak
    cat > /etc/security/limits.conf << EOF
# /etc/security/limits.conf
#
#This file sets the resource limits for the users logged in via PAM.
#It does not affect resource limits of the system services.
#
#Also note that configuration files in /etc/security/limits.d directory,
#which are read in alphabetical order, override the settings in this
#file in case the domain is the same or more specific.
#That means for example that setting a limit for wildcard domain here
#can be overriden with a wildcard setting in a config file in the
#subdirectory, but a user specific setting here can be overriden only
#with a user specific setting in the subdirectory.
#
#Each line describes a limit for a user in the form:
#
#<domain>        <type>  <item>  <value>
#
#Where:
#<domain> can be:
#        - a user name
#        - a group name, with @group syntax
#        - the wildcard *, for default entry
#        - the wildcard %, can be also used with %group syntax,
#                 for maxlogin limit
#
#<type> can have the two values:
#        - "soft" for enforcing the soft limits
#        - "hard" for enforcing hard limits
#
#<item> can be one of the following:
#        - core - limits the core file size (KB)
#        - data - max data size (KB)
#        - fsize - maximum filesize (KB)
#        - memlock - max locked-in-memory address space (KB)
#        - nofile - max number of open file descriptors
#        - rss - max resident set size (KB)
#        - stack - max stack size (KB)
#        - cpu - max CPU time (MIN)
#        - nproc - max number of processes
#        - as - address space limit (KB)
#        - maxlogins - max number of logins for this user
#        - maxsyslogins - max number of logins on the system
#        - priority - the priority to run user process with
#        - locks - max number of file locks the user can hold
#        - sigpending - max number of pending signals
#        - msgqueue - max memory used by POSIX message queues (bytes)
#        - nice - max nice priority allowed to raise to values: [-20, 19]
#        - rtprio - max realtime priority
#
#<domain>      <type>  <item>         <value>
#
#*               soft    core            0
#*               hard    rss             10000
#@student        hard    nproc           20
#@faculty        soft    nproc           20
#@faculty        hard    nproc           50
#ftp             hard    nproc           0
#@student        -       maxlogins       4


# End of file
* soft           nofile           204800
* hard           nofile           204800
* soft           nproc            204800
* hard           nproc            204800
EOF

#  *          代表针对所有用户   
# nproc      是代表最大进程数   
# nofile     是代表最大文件打开数 
# soft nofile表示软限制，hard nofile表示硬限制，软限制要小于等于硬限制。

cat > /etc/security/limits.d/90-nproc.conf << EOF
* soft nproc 204800
* hard nproc 204800
EOF

cat > /etc/security/limits.d/def.conf << EOF
* soft nproc 204800
* hard nproc 204800
EOF
}

#add user
add_user(){
    useradd www
    echo "GoodLuck2019"|passwd --stdin www
    mkdir -p /home/www/.ssh/
    chmod 700 /home/www/.ssh/
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyrgnAdfukV1xAllnl/IEFh/T9X4BkRlhSNMarwZIhZJ8S9euxz4PciAZTVqZ7zudcaPxjZGhtfa6ak5DHPW5GBr/DJ8Zh9Vk9p/c19szAUw04Go/ZuwaaSjIgdJwctfxnbBRVMSqMZFozc97MSh6yWoxLA3k2CWzv0yl9sjs3uUcYqe67GcFZaNQiomSGEKeBCxxtKQZyUEV2F7ufcoDIgcm9m2DH//DSflLd8QAyOj4Y4vj5Qcr8lThV9pWhjYq/sD1spxGbplz7+NQJeV8HEC5AzA1jZXy+pTFyV6DEOhPnn4V+GWUiDF39S8ky1wx0UpzpGxSRpTXhu1f9126B" > /home/www/.ssh/authorized_keys
    chmod 600 /home/www/.ssh/authorized_keys
    chown www:www -R /home/www
    echo "#######################################################"
    echo "add user www OK!!"
}

#set sshd
ssh_config(){
    mv -f /etc/ssh/sshd_config /etc/ssh/sshd_config-default_bak
    cat >/etc/ssh/sshd_config<<EOF
Port 33389
ListenAddress 0.0.0.0:22
ListenAddress 0.0.0.0:33389
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key
SyslogFacility AUTHPRIV
#PermitRootLogin no    #禁用root 登录
#RSAAuthentication yes #通过RSA认证
PubkeyAuthentication yes
AuthorizedKeysFile      %h/.ssh/authorized_keys
#PasswordAuthentication no #禁止密码方式验证
ChallengeResponseAuthentication no
GSSAPIAuthentication no
GSSAPICleanupCredentials no
UsePAM yes
X11Forwarding yes
UseDNS no
AcceptEnv LANG LC_CTYPE LC_NUMERIC LC_TIME LC_COLLATE LC_MONETARY LC_MESSAGES
AcceptEnv LC_PAPER LC_NAME LC_ADDRESS LC_TELEPHONE LC_MEASUREMENT
AcceptEnv LC_IDENTIFICATION LC_ALL LANGUAGE
AcceptEnv XMODIFIERS
Subsystem       sftp    /usr/libexec/openssh/sftp-server
EOF
    echo "#######################################################"
    if [ $RELEASEVER == 6 ];then
        /etc/init.d/sshd restart
        echo "Centos6 sshd_config set OK!!"
    fi
    if [ $RELEASEVER == 7 ];then
        systemctl restart sshd
        echo "Centos7 sshd_config set OK!!"
    fi
}

ipv6_config(){
    cat > /etc/modprobe.d/ipv6.conf << EOFI
#
#
#
#---------------custom-----------------------
#
alias net-pf-10 off
options ipv6 disable=1
EOFI

sed -i "/^NETWORKING_IPV6.*/d" /etc/sysconfig/network
echo "NETWORKING_IPV6=off" >> /etc/sysconfig/network
cat /etc/sysconfig/network | grep NETWORKING_IPV6
}

#set sysctl
sysctl_config(){
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
    cat > /etc/sysctl.conf << \EOF
net.ipv4.ip_forward = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 32768
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_keepalive_time = 30
net.ipv4.ip_local_port_range = 1024 65000
vm.overcommit_memory = 1
EOF
    /sbin/sysctl -p
    source /etc/profile
    echo "#######################################################"
    echo "sysctl set OK!!"
}


#audit_log
audit_log(){
    mkdir -pv /var/log/shell_audit
    touch /var/log/shell_audit/audit.log

    chown nobody:nobody /var/log/shell_audit/audit.log
    chmod 002 /var/log/shell_audit/audit.log

    chattr +a /var/log/shell_audit/audit.log

    echo "HISTSIZE=2048" >> /etc/profile
    echo 'HISTTIMEFORMAT="%Y/%m/%d %T   ";export HISTTIMEFORMAT' >> /etc/profile
    echo "export HISTORY_FILE=/var/log/shell_audit/audit.log" >> /etc/profile
    echo "export PROMPT_COMMAND='{ code=$?;thisHistID=`history 1|awk "{print \\$1}"`;lastCommand=`history 1| awk "{\\$1=\"\" ;print}"`;user=`id -un`;whoStr=(`who -u am i`);realUser=${whoStr[0]};logDay=${whoStr[2]};logTime=${whoStr[3]};pid=${whoStr[5]};ip=${whoStr[6]};if [ ${thisHistID}x != ${lastHistID}x ];then echo -E `date "+%Y/%m/%d %H:%M:%S"` $user\($realUser\)@$ip[PID:$pid][LOGIN:$logDay $logTime] --- [$PWD]$lastCommand [$code];lastHistID=$thisHistID;fi; } >> $HISTORY_FILE'" >> /etc/profile

    cat >/etc/logrotate.d/shell_audit<<EOF
/var/log/shell_audit/audit.log { 
    weekly  
    missingok 
    dateext 
    rotate 100
    sharedscripts 
    prerotate 
    /usr/bin/chattr -a /var/log/shell_audit/audit.log 
    endscript 
    sharedscripts 
    postrotate 
      /bin/touch /var/log/shell_audit/audit.log
      /bin/chmod 002 /var/log/shell_audit/audit.log
      /bin/chown nobody:nobody /var/log/shell_audit/audit.log
      /usr/bin/chattr +a /var/log/shell_audit/audit.log
    endscript 
}
EOF
}

main(){
    yum_config
    iptables_config
    system_bash
    system_config
    ulimit_config
    add_user
    ssh_config
    ipv6_config
    sysctl_config
    #audit_log
}
main
