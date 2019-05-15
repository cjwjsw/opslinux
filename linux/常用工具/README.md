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
参考资料


http://dsl000522.blog.sohu.com/200854305.html  
