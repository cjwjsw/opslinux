# 一、zabbix_agent安装包和脚本批量下发
```
第一套（Centos7）
cd /srv/salt/
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "systemctl stop zabbix-agent"
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "rm -rf /etc/zabbix/"
salt-cp -E "fhex-one-0[5-9]|fhex-one-10" zabbix_agent_v4.0.tar.gz /tmp/
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "tar -zxvf /tmp/zabbix_agent_v4.0.tar.gz -C /etc/"
salt -E "fhex-one-0[5-9]|fhex-one-10" cmd.run "systemctl restart zabbix-agent"

第一套（Ubuntu）




第三套（Centos7）

```
