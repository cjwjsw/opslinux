# 一、salt分组配置
```
[root@ip-172-31-30-95 /etc/salt]# cat master
 nodegroups:
   centos7-1rd: 'L@fhex-one-05,fhex-one-06,fhex-one-07,fhex-one-08,fhex-one-09,fhex-one-10'
   ubuntu-1rd: 'L@fhex-one-01,fhex-one-02,fhex-one-03,fhex-one-04'
   centos7-2rd: 'L@jys001,jys002,jys003,jys004,jys005'
   ubuntu-2rd: 'L@jys005,jys006'
   centos7-3rd: 'L@fhex-one-com-3rd-01,fhex-one-com-3rd-02,fhex-one-com-3rd-03,fhex-one-com-3rd-04,fhex-one-com-3rd-05,fhex-one-com-3rd-06'
   centos-all: 'G@os:Centos'
   ubuntu-all: 'G@os:Ubuntu'
 file_recv: True
 file_recv_max_size: 100000
 file_roots:
   base:
     - /srv/salt/
 pillar_roots:
  base:
    - /srv/pillar
    
    
#salt分组测试
salt -N centos-all test.ping

salt -N ubuntu-all test.ping

salt -N centos7-1rd test.ping

salt -N ubuntu-1rd test.ping
```
# 二、zabbix_agent安装包和脚本批量下发
```
第一套（Centos7）（注意zabbix_server在fhex-one-10机器）
cd /srv/salt/
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "systemctl stop zabbix-agent"
salt -E "fhex-one-0[5-9]" cmd.run "cp -rf /etc/zabbix/ /tmp/zabbix_bak"
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "rm -rf /etc/zabbix/"
salt-cp -E "fhex-one-0[5-9]|fhex-one-10" zabbix_agent_v4.0.tar.gz /tmp/
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "tar -zxvf /tmp/zabbix_agent_v4.0.tar.gz -C /etc/"
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "systemctl restart zabbix-agent"


第二套（Centos7）
cd /srv/salt/
salt -N centos7-2rd cmd.run "systemctl stop zabbix-agent"
salt -N centos7-2rd cmd.run "cp -rf /etc/zabbix/ /tmp/zabbix_bak"
salt -N centos7-2rd cmd.run "rm -rf /etc/zabbix/"
salt-cp -N centos7-2rd zabbix_agent_v4.0.tar.gz /tmp/
salt -N centos7-2rd cmd.run "tar -zxvf /tmp/zabbix_agent_v4.0.tar.gz -C /etc/"
salt -N centos7-2rd cmd.run "systemctl restart zabbix-agent"


第三套（Centos7）
cd /srv/salt/
salt "fhex-one-com-3rd-0*" cmd.run "systemctl stop zabbix-agent"
salt "fhex-one-com-3rd-0*" cmd.run "rm -rf /etc/zabbix/"
salt-cp "fhex-one-com-3rd-0*" zabbix_agent_v4.0.tar.gz /tmp/
salt "fhex-one-com-3rd-0*" cmd.run "tar -zxvf /tmp/zabbix_agent_v4.0.tar.gz -C /etc/"
salt "fhex-one-com-3rd-0*" cmd.run "systemctl restart zabbix-agent"


Ubunut系统下发
cd /srv/salt/
salt -N ubuntu-all cmd.run "systemctl stop zabbix-agent"
salt -N ubuntu-all cmd.run "cp -rf /etc/zabbix/ /tmp/zabbix_bak"
salt -N ubuntu-all cmd.run "rm -rf /etc/zabbix/"
salt-cp -N ubuntu-all zabbix_agent_ubuntu_v4.0.tar.gz /tmp/
salt -N ubuntu-all cmd.run "tar -zxvf /tmp/zabbix_agent_ubuntu_v4.0.tar.gz -C /etc/"
salt -N ubuntu-all cmd.run "systemctl restart zabbix-agent"
```

# 三、zabbix_agent安装包和脚本单台主机下发

```
cd /srv/salt/
salt "jys006" cmd.run "systemctl stop zabbix-agent"
salt "jys006" cmd.run "rm -rf /etc/zabbix/"
salt-cp "jys006" zabbix_agent_v4.0.tar.gz /tmp/
salt "jys006" cmd.run "tar -zxvf /tmp/zabbix_agent_v4.0.tar.gz -C /etc/"
salt "jys006" cmd.run "systemctl restart zabbix-agent"
```

参考资料

https://www.cnblogs.com/snailshadow/p/8214294.html 
