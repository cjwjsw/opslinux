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
那么，$clientRealIP就是用户真实IP了，其实就是匹配了 $http_x_forwarded_for 的第一个值，具体原理前文也简单分享过：


    其实，当一个 CDN 或者透明代理服务器把用户的请求转到后面服务器的时候，这个 CDN 服务器会在 Http 的头中加入一个记录
    X-Forwarded-For : 用户IP, 代理服务器IP
    如果中间经历了不止一个代理服务器，这个记录会是这样
    X-Forwarded-For : 用户IP, 代理服务器1-IP, 代理服务器2-IP, 代理服务器3-IP, ….
    可以看到经过好多层代理之后， 用户的真实IP 在第一个位置， 后面会跟一串中间代理服务器的IP地址，从这里取到用户真实的IP地址，针对这个 IP 地址做限制就可以了。

而且代码中还配合使用了 $remote_addr，因此$clientRealIP 还能兼容上文中第1种直接访问模式，不像 $http_x_forwarded_for 在直接访问模式中将会是空值！

所以，$clientRealIP 还能配置到 Nginx 日志格式中，替代传统的 $remote_addr 使用，推荐！
## 三、隔山打牛
既然已经拿到了真实IP，却不能使用 iptables 和 deny 指令，是否无力感油然而生？

哈哈，在强大的 Nginx 面前只要想得到，你就做得到！通过对 $clientRealIP 这个变量的判断，Nginx就能实现隔山打牛的目的，而且规则简单易懂：
```
#如果真实IP为 121.42.0.18、121.42.0.19，那么返回403
if ($clientRealIp ~* "121.42.0.18|121.42.0.19") {
        #如果你的nginx安装了echo模块，还能如下输出语言，狠狠的发泄你的不满(但不兼容返回403,试试200吧)！
        #add_header Content-Type text/plain;
        #echo "son of a bitch,you mother fucker,go fuck yourself!";
        return 403;
        break;
}
```
把这个保存为 deny_ip.conf ，上传到 Nginx 的 conf 文件夹，然后在要生效的网站 server 模块中引入这个配置文件，并 Reload 重载 Nginx 即可生效：

#禁止某些用户访问
include deny_ip.conf;

如果再想添加其他要禁止的IP，只需要编辑这个文件，插入要禁止的IP，使用分隔符 | 隔开即可，记得每次修改都需要 reload 重载 Nginx才能生效。
