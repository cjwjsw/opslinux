# 一、consul-a-install.sh

```
yum install -y epel-release
yum install -y bind-utils unzip jq
cd ~/
wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip
unzip consul_1.0.2_linux_amd64.zip
mv consul /usr/local/bin/
adduser consul
mkdir /etc/consul.d
chown -R consul:consul /etc/consul.d/
mkdir /var/consul
chown -R consul:consul /var/consul
consul keygen # generate encryption key that will be used ad the "encrypt" entry of ALL CONSUL NODES

# creeate bootstrap consul configuration
sudo tee /etc/consul.d/consul.json << 'EOF'
{
    "bootstrap": true,
    "server": true,
    "datacenter": "dc1",
    "data_dir": "/var/consul",
    "encrypt": "[output of consul keygen]"
}
EOF

sudo tee /etc/systemd/system/consul.service << 'EOF'
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
User=consul
Group=consul
PIDFile=/run/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent $OPTIONS -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl start consul.service
systemctl status consul.service
systemctl enable consul.service


# create configuration used after bootstrapping. The assumption is that
# the IP addres of this server is 192.168.100.51 and the
# other consul nodes are 192.168.100.52 & 192.168.100.53
sudo tee /etc/consul.d/consul.json << 'EOF'
{
  "node_name": "consul-a",
  "bootstrap": false,
  "data_dir": "/var/consul",
  "server": true,
  "bind_addr": "192.168.100.51",
  "bootstrap_expect": 3,
  "ui": true,
  "client_addr": "0.0.0.0",
  "encrypt": "[output of consul keygen]",
  "start_join": ["192.168.100.52","192.168.100.53"]
}
EOF
```

# 二、consul-b-install.sh

```
yum install -y epel-release
yum install -y bind-utils unzip jq
cd ~/
wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip
unzip consul_1.0.2_linux_amd64.zip
mv consul /usr/local/bin/
adduser consul
mkdir /etc/consul.d
chown -R consul:consul /etc/consul.d/
mkdir /var/consul
chown -R consul:consul /var/consul

# The assumption is that the IP addres of this server is 192.168.100.52
# and the other consul servers are 192.168.100.51 & 192.168.100.53
sudo tee /etc/consul.d/consul.json << 'EOF'
{
  "node_name": "consul-b",
  "bootstrap": false,
  "data_dir": "/var/consul",
  "server": true,
  "bind_addr": "192.168.100.52",
  "bootstrap_expect": 3,
  "ui": true,
  "client_addr": "0.0.0.0",
  "encrypt": "[output of consul-a 'consul keygen' command]",
  "start_join": ["192.168.100.51","192.168.100.53"]
}
EOF

sudo tee /etc/systemd/system/consul.service << 'EOF'
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
User=consul
Group=consul
PIDFile=/run/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent $OPTIONS -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl start consul.service
systemctl status consul.service
systemctl enable consul.service
```

# 三、consul-b-install.sh

```
yum install -y epel-release
yum install -y bind-utils unzip jq
cd ~/
wget https://releases.hashicorp.com/consul/1.0.2/consul_1.0.2_linux_amd64.zip
unzip consul_1.0.2_linux_amd64.zip
mv consul /usr/local/bin/
adduser consul
mkdir /etc/consul.d
chown -R consul:consul /etc/consul.d/
mkdir /var/consul
chown -R consul:consul /var/consul

# The assumption is that the IP addres of this server is 192.168.100.53
# and the other consul servers are 192.168.100.51 & 192.168.100.52
sudo tee /etc/consul.d/consul.json << 'EOF'
{
  "node_name": "consul-c",
  "bootstrap": false,
  "data_dir": "/var/consul",
  "server": true,
  "bind_addr": "192.168.100.53",
  "bootstrap_expect": 3,
  "ui": true,
  "client_addr": "0.0.0.0",
  "encrypt": "[output of consul-a 'consul keygen' command]",
  "start_join": ["192.168.100.51","192.168.100.52"]
}
EOF

sudo tee /etc/systemd/system/consul.service << 'EOF'
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network.target

[Service]
User=consul
Group=consul
PIDFile=/run/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStart=/usr/local/bin/consul agent $OPTIONS -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl start consul.service
systemctl status consul.service
systemctl enable consul.service
```


参考文档：

https://gist.github.com/sdorsett/5cf05bb5e02f1e4a20224bae62b375ea
