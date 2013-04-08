#include "ODSocket.h"
#include <stdio.h>
#include<vector>
#include <string>
using namespace std;

#ifdef WIN32
	#pragma comment(lib, "wsock32")
#endif


ODSocket::ODSocket(SOCKET sock)
{
	m_sock = sock;
}

ODSocket::~ODSocket()
{
}

int ODSocket::Init()
{
#ifdef WIN32
	WSADATA wsaData;
	WORD version = MAKEWORD(2, 0);
	int ret = WSAStartup(version, &wsaData);//win sock start up
	if ( ret ) {
		return -1;
	}
#endif
	return 0;
}
//this is just for windows
int ODSocket::Clean()
{
#ifdef WIN32
		return (WSACleanup());
#endif
		return 0;
}

ODSocket& ODSocket::operator = (SOCKET s)
{
	m_sock = s;
	return (*this);
}

ODSocket::operator SOCKET ()
{
	
	return m_sock;
}
//create a socket object win/lin is the same
// af:
bool ODSocket::Create(int af, int type, int protocol)
{
	m_sock = socket(af, type, protocol);
	if ( m_sock == INVALID_SOCKET ) {
		return false;
	}

	/*unsigned long flag=1; 
	if (ioctlsocket(m_sock,FIONBIO,&flag)!=0) 
	{ 
		closesocket(m_sock); 
		return false; 
	} */
//	struct timeval tv_out;
////	struct timeval tv_out;
//	tv_out.tv_sec = 3;
//	tv_out.tv_usec = 0;
//	setsockopt(m_sock, SOL_SOCKET, SO_RCVTIMEO, (char*)&tv_out, sizeof(tv_out));


	//int TimeOut=6000; //设置发送超时6秒

	//if(::setsockopt(m_sock, SOL_SOCKET, SO_SNDTIMEO, (char *)&TimeOut, sizeof(TimeOut)) == SOCKET_ERROR)
	//{
	//	return 0;
	//}

	//TimeOut=6000;//设置接收超时6秒
	//if(::setsockopt(m_sock, SOL_SOCKET, SO_RCVTIMEO, (char *)&TimeOut, sizeof(TimeOut)) == SOCKET_ERROR)
	//{
	//	return 0;
	//}
	//设置非阻塞方式连接
	/*unsigned long ul = 1;
	int ret = ioctlsocket(m_sock, FIONBIO, (unsigned long*)&ul);
	if (ret == SOCKET_ERROR) return 0;*/
	return true;
}

bool ODSocket::Connect(const char* ip, unsigned short port)
{
	//struct sockaddr_in serv_addr;
	//serv_addr.sin_family=AF_INET; 
	//serv_addr.sin_port=htons(port); 
	//int ret = inet_pton(AF_INET,argv[1],&addr);
	//memcpy(&serv_addr.sin_addr,&addr,sizeof(struct in_addr));
	//// serv_addr.sin_addr.s_addr = htons(atoi(argv[1])); 
	//bzero( &(serv_addr.sin_zero),8);
	//fprintf(stderr,"line:%d\n",__LINE__); 
	//if (connect(sockfd, (struct sockaddr *) &serv_addr, 
	//	sizeof(struct sockaddr)) == -1) { 
	//		perror("connect出错！"); 
	//		exit(1); 
	//} 

	struct sockaddr_in svraddr;
	svraddr.sin_family = AF_INET;
	svraddr.sin_addr.s_addr = inet_addr(ip);
	svraddr.sin_port = htons(port);
	int ret = connect(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
	if ( ret == SOCKET_ERROR ) {
		return false;
	}

	
	return true;
}

bool ODSocket::Bind(unsigned short port)
{
	struct sockaddr_in svraddr;
	svraddr.sin_family = AF_INET;
	svraddr.sin_addr.s_addr = INADDR_ANY;
	svraddr.sin_port = htons(port);

	int opt =  1;
	if ( setsockopt(m_sock, SOL_SOCKET, SO_REUSEADDR, (char*)&opt, sizeof(opt)) < 0 ) 
		return false;

	int ret = bind(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
	if ( ret == SOCKET_ERROR ) {
		return false;
	}

	
	return true;
}
//for server
bool ODSocket::Listen(int backlog)
{
	int ret = listen(m_sock, backlog);
	if ( ret == SOCKET_ERROR ) {
		return false;
	}
	return true;
}

bool ODSocket::Accept(ODSocket& s, char* fromip)
{
	struct sockaddr_in cliaddr;
	socklen_t addrlen = sizeof(cliaddr);
	SOCKET sock = accept(m_sock, (struct sockaddr*)&cliaddr, &addrlen);
	if ( sock == SOCKET_ERROR ) {
		return false;
	}

	s = sock;
	if ( fromip != NULL )
		sprintf(fromip, "%s", inet_ntoa(cliaddr.sin_addr));

	return true;
}

int ODSocket::Send(const char* buf, int len, int flags)
{
	int bytes;
	int count = 0;

	while ( count < len ) {

		bytes = send(m_sock, buf + count, len - count, flags);
		if ( bytes == -1 || bytes == 0 )
			return -1;
		count += bytes;
	} 
	is_getData = true;
	return count;
}

int ODSocket::Recv(char* buf, int len, int flags)
{
	vector<string> ch;
	string respons ="";
	int type = 0;
	int time_num = 0;
	int bytes;

	int buffer_len = 100;

	char buffer[101] = "\0";

	while(1) {
		// 接收数据
		bytes = recv(m_sock , buffer , buffer_len , 0);

		if( bytes != 0 ) {

			if( strlen(buffer) > bytes ) {
				char buffer2[101] = "\0";
				strncpy(buffer2 , buffer , bytes);
				ch.push_back( buffer2 );	//把元素一个一个存入到vector中
				//printf("%d\n" , strlen(buffer2));
			} else {
				ch.push_back( buffer );	//把元素一个一个存入到vector中
			}

			// ch.push_back( buffer );
		}

		//printf("%d - %d\n" , bytes , strlen(buffer));

		if(bytes == SOCKET_ERROR) {
			printf("接收数据失败!\n");
			return 0;
		}

		if( bytes == 0 || (bytes < buffer_len && buffer[bytes - 1] == '\n' ) ) {
			int j = 0;
			for(std::vector<std::string> ::iterator it = ch.begin();it != ch.end();++it,j++){
				respons+=it->data();
			} 
			strcpy(buf,respons.c_str()) ;

			//printf("total length: %d" , strlen(buf));
			printf("接收数据完成!\n");
			return 0;
		}
	}

	return 0;

	/*std::string reposnt = "";
	char recvBuff[1024];
	int type = 0;
	bool is_socket = true;
	while(is_socket) {
		memset(recvBuff,'\0',1024);
		type = recv(m_sock,recvBuff,1024,0);    
		printf("recv msg from client: %s \n",recvBuff);
		reposnt +=recvBuff;
		if (type<0)
		{
			is_socket = false;
		}
	}*/
	//return recv(m_sock,buf,len,0);
}

int ODSocket::Close()
{
#ifdef WIN32
	return (closesocket(m_sock));
#else
	return (close(m_sock));
#endif
}

int ODSocket::GetError()
{
#ifdef WIN32
	return (WSAGetLastError());
#else
	return (errno);
#endif
}

bool ODSocket::DnsParse(const char* domain, char* ip)
{
	struct hostent* p;
	if ( (p = gethostbyname(domain)) == NULL )
		return false;
		
	sprintf(ip, 
		"%u.%u.%u.%u",
		(unsigned char)p->h_addr_list[0][0], 
		(unsigned char)p->h_addr_list[0][1], 
		(unsigned char)p->h_addr_list[0][2], 
		(unsigned char)p->h_addr_list[0][3]);
	
	return true;
}


//char* ODSocket::G2U(const char* gb2312)
//{
//	int len = MultiByteToWideChar(CP_ACP, 0, gb2312, -1, NULL, 0);
//	wchar_t* wstr = new wchar_t[len+1];
//	memset(wstr, 0, len+1);
//	MultiByteToWideChar(CP_ACP, 0, gb2312, -1, wstr, len);
//	len = WideCharToMultiByte(CP_UTF8, 0, wstr, -1, NULL, 0, NULL, NULL);
//	char* str = new char[len+1];
//	memset(str, 0, len+1);
//	WideCharToMultiByte(CP_UTF8, 0, wstr, -1, str, len, NULL, NULL);
//	if(wstr) delete[] wstr;
//	return str;
//}