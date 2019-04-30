```
consul agent -server -bootstrap-expect=2 -data-dir=/var/consul -node=node0 -bind=192.168.56.11 -datacenter=dc1 -config-dir=/var/consul


consul agent -server -bootstrap-expect=2 -data-dir=/var/consul -node=node1 -bind=192.168.56.12 -datacenter=dc1 -config-dir=/var/consul


consul agent -data-dir=/var/consul -node=node3 -bind=192.168.56.13 -client=192.168.56.13 -datacenter=dc1 -ui -config-dir=/var/consul
```

参考链接：

https://www.cnblogs.com/xiaohanlin/p/8016803.html   服务发现 - consul 的介绍、部署和使用


https://www.lijiaocn.com/%E9%A1%B9%E7%9B%AE/2018/08/17/consul-usage.html  服务治理工具consul的功能介绍与使用入门
