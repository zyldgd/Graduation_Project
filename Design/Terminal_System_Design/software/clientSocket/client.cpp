#include <stdio.h>
#include <iostream>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string>
#include <string.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>

#define bufsize 256


int clientSock_fd;
struct sockaddr_in serverAddr; //服务器端网络地址结构体
char buf[bufsize];  //数据传送的缓冲区


void *receiveFun(void *arg)
{
	int len = 0;
	char buffer[1024];
	while(true)
	{
		len = recv(clientSock_fd, buffer, 1024, 0);
		if(len>0 && len<1024)
		{
			buffer[len] = '\0';
			printf("[recv]: %s\n", buffer);
			if(buffer[0]=='q')
				break;
		}
		else
		{
			perror("[err]: receive err!\n");
			break;
		}
	}
	return NULL;
}

int main(int argc, char *argv[])
{
		
    serverAddr.sin_family      = AF_INET; //设置为IP通信
	serverAddr.sin_addr.s_addr = inet_addr("134.175.168.24");//服务器IP地址
	serverAddr.sin_port        = htons(8000); //服务器端口号
	
	/*创建客户端套接字--IPv4协议，面向连接通信，TCP协议*/
	if((clientSock_fd = socket(PF_INET, SOCK_STREAM, 0))<0)
	{
		perror("socket error");
		return 1;
	}
	
	/*将套接字绑定到服务器的网络地址上*/
	if(connect(clientSock_fd, (struct sockaddr *)&serverAddr, sizeof(struct sockaddr))<0)
	{
		perror("connect error");
		return 1;
	}

	printf("connected to server \n");
	
	pthread_t thread0;
	pthread_create(&thread0, NULL, receiveFun, NULL);
	


	int len = 0;
	std::string buf;
	while(getline(std::cin, buf))
	{
		len=send(clientSock_fd, buf.c_str(), buf.size(), 0);
	}
	
	pthread_join(thread0, NULL);

	close(clientSock_fd);
    
	return 0;
}

