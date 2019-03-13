## 利用tcpdump监控tcp连接三次握手和关闭四次握手


学习网络编程最主要的是能理解底层编程细节，一开始看《UNIX网络编程卷1：套接字联网API》的时候搞不懂什么seq、ack到底是什么东西，最近了解了tcpdump的一些用法后感觉两者结合起来还是比较容易理握手过程的。以下就通过tcpdump工具来监控相关内容，并和书本上的流程进行对比介绍，希望对入门的童靴有些帮助吧

## 一、服务端代码如下：
```
#include <sys/socket.h> //socket listen bind                                     
#include <arpa/inet.h> // sockaddr head                                                                                                                                                                   
#include <string.h>  //memset and strlen head                                       
#include <sys/socket.h> //socket listen bind                                        
#include <iostream>                                                                 
#include <time.h>                                                                   
#include <stdio.h>                                                                  
                                                                                    
#define MAXLINE 4096                                                                
#define LISTENQ 1024                                                                
                                                                                    
using namespace std;                                                                
                                                                                    
int main(int argc, char ** argv)                                                    
{                                                                                   
    int listenfd, connfd;                                                           
    socklen_t len;                                                                  
    struct sockaddr_in servaddr, cliaddr;                                           
    char buff[MAXLINE];                                                             
    time_t ticks;                                                                   
    listenfd = socket(AF_INET, SOCK_STREAM, 0);                                     
    memset(&servaddr, 0, sizeof(servaddr));                                         
    servaddr.sin_family = AF_INET;                                                  
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY);                                   
    servaddr.sin_port = htons(10000);                                               
                                                                                    
    bind(listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr));                 
    int ret = listen(listenfd,LISTENQ);                                             
    cout << "go to listen" <<ret<< endl;                                            
    for(; ;)                                                                        
    {                                                                               
        len=sizeof(cliaddr);                                                        
        connfd = accept(listenfd, (struct sockaddr *)&cliaddr, &len);               
        cout << "connfd = " << connfd << inet_ntop(AF_INET, &cliaddr.sin_addr, buff, sizeof(buff)) << endl;
        sleep(20);                                                                  
        ticks = time(NULL);                                                         
        snprintf(buff, sizeof(buff), "%.24s\r\n", ctime(&ticks));                   
        write(connfd, buff, strlen(buff));                                          
        cout << "write date ok" << endl;                                            
        sleep(20);                                                                  
        close(connfd);                                                              
    } 
    return 0;                                                                    
}  
```

## 二、客户端代码如下：
 ```
 #include <string.h>                                                                 
#include <netinet/in.h>                                                             
#include <sys/socket.h>                                                             
#include <arpa/inet.h>                                                              
#include <iostream>                                                                 
#include <stdio.h>                                                                  
#include <errno.h>                                                               
                                                                                 
using namespace std;                                                             
                                                                                 
#define MAXLINE     4096    /* max text line length */                           
int main(int argc, char ** argv)                                                 
{                                                                                
    int sockfd, n;                                                               
    char recvline[MAXLINE+1];                                                    
    struct sockaddr_in serveraddr;                                               
    if(argc != 2)                                                                
    {                                                                            
        cout << "para error " << endl;                                           
        return 0;                                                                
    }                                                                            
    if((sockfd=socket(AF_INET, SOCK_STREAM, 0))<0)                               
    {                                                                            
        cout << "socket error" << endl;                                          
        return 0;                                                                
    }                                                                            
    memset(&serveraddr,0, sizeof(serveraddr));                                   
    serveraddr.sin_family = AF_INET;                                             
    serveraddr.sin_port = htons(10000);                                          
    if(inet_pton(AF_INET, argv[1], &serveraddr.sin_addr)<=0)                     
    {                                                                            
        cout << "inet_pton error for " << argv[1] << endl;                       
        return 0;                                                                
    }                                                                            
    int tmp = connect(sockfd, (struct sockaddr *)&serveraddr, sizeof(serveraddr));
    if(tmp <0)                                                                                                                                                                                            
    {                                                                               
        cout << "connect error" << tmp << endl;                                     
        cout << "error info " << errno << endl;                                     
        return 0;                                                                   
    } 
    while((n=read(sockfd, recvline, MAXLINE)) > 0)                               
    {                                                                            
        recvline[n] = 0;                                                         
        if(fputs(recvline, stdout) == EOF)                                       
        {                                                                        
            cout << "fputs error" << endl;                                       
        }                                                                        
    }                                                                            
    close(sockfd);                                                               
    if(n<0)                                                                      
    {                                                                            
        cout << "read error" << endl;                                            
    }                                                                            
    return 1;                                                                    
} 
 ```
 
 先在192.168.11.220上运行服务端程序，然后在192.168.11.223上运行客户端程序。同时在两个服务器上以root用户执行tcpdump工具，监控10000端口

tcpdump命令如下：
```
tcpdump 'port 10000' -i eth0 -S
```
建立连接时服务端220的监控内容如下：
```sh
14:52:19.772673 IP 192.168.11.223.55081 > npsc-220.ndmp: Flags [S], seq 1925249825, win 14600, options [mss 1460,sackOK,TS val 11741993 ecr 0,nop,wscale 6], length 0 
14:52:19.772695 IP npsc-220.ndmp > 192.168.11.223.55081: Flags [S.], seq 821610649, ack 1925249826, win 14480, options [mss 1460,sackOK,TS val 20292985 ecr 11741993,nop,wscale 7], length 0 
14:52:19.773256 IP 192.168.11.223.55081 > npsc-220.ndmp: Flags [.], ack 821610650, win 229, options [nop,nop,TS val 11741994 ecr 20292985], length 0

```
 下面结合上图和下面三次握手示意图，解释握手细节： 
 第一行显示客户端192.168.11.223先发送一个seq,1925249825给服务端，对应下面三次握手示意图中的SYN J

第二行显示服务端192.168.11.220（npsc-220）确认第一行的请求:seq 1925249825, ack的值为第一行的seq值+1，即(ack 1925249826），同时发送一个请求序列号821610649。对应下图三次握手中的（SYN K, ACK J+1）

第三行显示客户端192.168.11.223确认服务端的请求序号（第二行中的seq 821610649），对应下图tcp三路握手中的 （ACK K+1）

参考文档：

https://blog.csdn.net/fly542/article/details/41348421
