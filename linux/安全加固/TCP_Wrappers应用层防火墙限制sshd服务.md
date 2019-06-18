# 一、TCP_Wrappers应用层防火墙 

TCP_Wrappers是一个工作在应用层的安全工具，它只能针对某些具体的应用或者服务起到一定的防护作用。比如说ssh、telnet、FTP等服务的请求，都会先受到TCP_Wrappers的拦截。

TCP_Wrappers是基于库调用实现的。

包名为tcp_wrappers-libs

```
[root@linux-node1 ~]# rpm -ql tcp_wrappers-libs
/usr/lib64/libwrap.so.0
/usr/lib64/libwrap.so.0.7.6
/usr/share/doc/tcp_wrappers-libs-7.6
/usr/share/doc/tcp_wrappers-libs-7.6/BLURB
/usr/share/doc/tcp_wrappers-libs-7.6/Banners.Makefile
/usr/share/doc/tcp_wrappers-libs-7.6/CHANGES
/usr/share/doc/tcp_wrappers-libs-7.6/DISCLAIMER
/usr/share/doc/tcp_wrappers-libs-7.6/README
/usr/share/doc/tcp_wrappers-libs-7.6/README.IRIX
/usr/share/doc/tcp_wrappers-libs-7.6/README.NIS
/usr/share/doc/tcp_wrappers-libs-7.6/README.ipv6
/usr/share/doc/tcp_wrappers-libs-7.6/README.ipv6.2
/usr/share/man/man5/hosts.allow.5.gz
/usr/share/man/man5/hosts.deny.5.gz
/usr/share/man/man5/hosts_access.5.gz
/usr/share/man/man5/hosts_options.5.gz
```

我们可以查询到好多服务都是调用的这个库文件,如sshd、vsftpd、xinetd

```
[root@linux-node1 ~]# ldd `which sshd` |grep libwrap.so.0
	libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f44b7239000)
  
[root@linux-node1 ~]# ldd `which xinetd` |grep libwrap.so.0
	libwrap.so.0 => /lib64/libwrap.so.0 (0x00007f61d0e1d000)
```

参考资料：

http://www.yulongjun.com/linux/20170720-01-tcp_wrappers/
