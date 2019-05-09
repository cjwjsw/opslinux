```
diff -qs <(ssh-keygen -yf ~/.ssh/id_rsa) <(cut -d ' ' -f 1,2 ~/.ssh/id_rsa.pub)

```

参考文档：

https://stackoverflow.com/questions/274560/how-do-you-test-a-public-private-dsa-keypair
