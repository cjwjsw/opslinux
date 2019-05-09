```
diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)

```

参考文档：

https://segmentfault.com/q/1010000008302009  怎么验证id_rsa.pub和id_rsa是否匹配


https://stackoverflow.com/questions/274560/how-do-you-test-a-public-private-dsa-keypair
