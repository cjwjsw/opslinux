# 一、安全加固
```
1、禁用root 远程登
PermitRootLogin no #禁用root 登录，创建一个普通用户用作远程登录，然后通过su - 转为root 用户

2、改ssh端口
#Port 22
Port 33389
ListenAddress 172.16.16.118:22
ListenAddress 0.0.0.0:33389
Port 33389 #改到一般扫描器扫到累死才能找到的端口（从20 扫到 36301 … 哈哈）

3、使用密钥认证登录服务器：
vim /etc/ssh/sshd_config

# 通过RSA认证
RSAAuthentication yes

# 允许pubKey（id_rsa.pub）登录
PubkeyAuthentication yes


4、禁止密码方式验证
PasswordAuthentication no #禁止密码方式验证
```

参考文档：

https://www.cnblogs.com/lcword/p/5917321.html
