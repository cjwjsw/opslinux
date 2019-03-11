## ps、grep和kill联合使用杀掉进程

```
ps -ef |grep hello |awk '{print $2}'|xargs kill -9

这里是输出ps -ef |grep hello 结果的第二列的内容然后通过xargs传递给kill -9,其实第二列内容就是hello的进程号！
```
