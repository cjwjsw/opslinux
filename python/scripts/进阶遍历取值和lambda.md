# 一、遍历取值
```
a=[{u'key': 310004788, u'doc_count': 93971}, {u'key': 310004790, u'doc_count': 93861}]
b=[ x["key"] for x in a ]
print b
```
  ![python01](https://github.com/Lancger/opslinux/blob/master/images/python01.png)
  
# 二、lambda
```
1、看个例子：
g = lambda x:x+1

看一下执行的结果：
g(1)
>>>2

g(2)
>>>3

可以这样认为,lambda作为一个表达式，定义了一个匿名函数，上例的代码x为入口参数，x+1为函数体，用函数来表示为：
1 def g(x):
2     return x+1
```

# 三、三元运算
```
# 普通条件语句
if 1 == 1:
    name = 'wupeiqi'
else:
    name = 'alex'
  
# 三元运算
name = 'wupeiqi' if 1 == 1 else 'alex'

```


参考资料：

https://www.cnblogs.com/caizhao/p/7905094.html
