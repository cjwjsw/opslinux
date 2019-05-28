# 一、awk计算(浮点型运算)

```
#!/bin/bash
cnt=1200
awk 'BEGIN{printf "%.0f\n",('$cnt'*'0.8')}'
```

# 二、整形运算
```
#!/bin/bash
cnt=1200
expr $cnt '*' 2
```

# 三、pstree
```
1、在 Mac OS上

      brew install pstree

2、在 Fedora/Red Hat/CentOS

      yum -y install psmisc

3、在 Ubuntu/Debian

     apt-get install psmisc
```
参考资料


http://dsl000522.blog.sohu.com/200854305.html  
