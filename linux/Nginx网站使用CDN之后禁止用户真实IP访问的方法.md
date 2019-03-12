# Nginx网站使用CDN之后禁止用户真实IP访问的方法 

   做过面向公网WEB的运维人员经常会遇见恶意扫描、拉取、注入等图谋不轨的行为，对于直接对外的WEB服务器，我们可以直接通过 iptables 、Nginx 的deny指令或是程序来ban掉这些恶意请求。

而对于套了一层 CDN 或代理的网站，这些方法可能就失效了。尤其是个人网站，可能就一台VPS，然后套一个免费的CDN就行走在互联网了。并不是每个CDN都能精准的拦截各种恶意请求的，更闹心的是很多CDN还不支持用户在CDN上添加BAN规则，比如腾讯云CDN。

因此，就有了本文的折腾分享。

## 一、真假难辨

如何禁止访问，我们先了解下常见的3种网站访问模式：

    用户直接访问对外服务的普通网站
    浏览器 --> DNS解析 --> WEB数据处理 --> 数据吐到浏览器渲染展示

    用户访问使用了CDN的网站
    浏览器 --> DNS解析 --> CDN节点 --> WEB数据处理 --> 数据吐到浏览器渲染展示

    用户通过代理上网访问了我们的网站
    浏览器 --> 代理上网 --> DNS解析 --> 上述2种模式均可能

对于第一种模式，我要禁止这个用户的访问很简单，可以直接通过 iptables 或者 Nginx的deny指令来禁止均可：
```
iptabels：
iptables -I INPUT -s 用户ip -j DROP
Nginx的deny指令：
语 法: deny address | CIDR | unix: | all;
默认值: —
配置段: http, server, location, limit_except
顺 序：从上往下
Demo：
location / {
  deny 用户IP或IP段;
}

```
但对于后面2种模式就无能为力了，因为iptables 和 deny 都只能针对直连IP，而后面2种模式中，WEB服务器直连IP是CDN节点或者代理服务器，此时使用 iptable 或 deny 就只能把 CDN节点 或代理IP给封了，可能误杀一大片正常用户了，而真正的罪魁祸首轻轻松松换一个代理IP又能继续请求了。

那我们可以通过什么途径去解决以上问题呢？
## 二、火眼金睛
如果长期关注张戈博客的朋友，应该还记得之前转载过一篇分享Nginx在CDN加速之后，获取用户真实IP做并发访问限制的方法。说明Nginx还是可以实实在在的拿到用户真实IP地址的，那么事情就好办了。

要拿到用户真实IP，只要在Nginx的http模块内加入如下配置：
```
#获取用户真实IP，并赋值给变量$clientRealIP
map $http_x_forwarded_for  $clientRealIp {
        ""      $remote_addr;
        ~^(?P<firstAddr>[0-9\.]+),?.*$  $firstAddr;
}
```
