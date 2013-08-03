#include "ODSocket.h"
#include <stdio.h>
#include <vector>
#include <string>


using namespace std;

#ifdef WIN32
	#pragma comment(lib , "wsock32")
	#pragma comment(lib , "libcurl_imp.lib")
	#pragma comment(lib , "pthreadVCE2.lib")
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
	int ret = WSAStartup(version, &wsaData);		//win sock start up
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


// create a socket object win/lin is the same
// af:
bool ODSocket::Create(int af, int type, int protocol)
{
	m_sock = socket(af , type , protocol);
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


bool ODSocket::Connect(const char* ip, unsigned short port, const char* type)
{
	char* temp = NULL;
	if(strcmp(type, "domain") == 0){
		hostent* host = gethostbyname(ip);
		temp = inet_ntoa(*((struct in_addr*)host->h_addr));
	}else{
		temp = new char[sizeof(ip)];
		strcpy(temp,ip);
	}
	
	struct sockaddr_in svraddr;
	svraddr.sin_family = AF_INET;
	svraddr.sin_addr.s_addr = inet_addr(temp);
	svraddr.sin_port = htons(port);
	int ret = connect(m_sock, (struct sockaddr*)&svraddr, sizeof(svraddr));
	if ( ret == SOCKET_ERROR ) {
		return false;
	}

	return true;
}


/*
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


// for server

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
*/


// 发送数据
int ODSocket::Send(const char* buf, int len, int flags)
{
	int bytes;
	int count = 0;

	// CCLog("%s" , buf);

	while ( count < len ) {

		bytes = send(m_sock, buf + count, len - count, flags);
		if ( bytes == -1 || bytes == 0 )
			return -1;
		count += bytes;
	} 
	is_getData = true;
	return count;
}


// 接收数据
int ODSocket::Recv(char* buf , int len , int flags)
{
	if(buf == NULL) return -1;

	int bytes;
	int buffer_len = 1000;

	char buffer[1001] = "\0";
	unsigned long length = 0;
	char total_len[10] = "\0";

	// 读取包头
	bytes = recv(m_sock , buffer , 1 , 0);
	if(bytes < 0) {
		return bytes;
	}
	
	length = atoi(buffer);

	recv(m_sock, buffer, length, 0);

	length = atoi(buffer);

	//if( bytes != 5    /*|| buffer[0] != 0xff*/ ) {
	//	unsigned long pack_header = 0;
	//	memcpy(&pack_header , &buffer , 1);

	//	if(pack_header != 255) {
	//		CCLog("%s" , "package header wrong");
	//		return -1;
	//	}
	//}

	//memcpy(&temp_int , &buffer[1] , bytes);
	//length = ntohl(temp_int);
	////length = 3907;

	if( length <= 0 ) return -1;


	// 接收数据
	unsigned long total_recv = 0;
	char * p = NULL;
	p = new char[length];

	while(1) {
		memset(buffer , 0 , buffer_len);

		bytes = recv(m_sock , buffer , buffer_len , 0);

		if( bytes != 0 ) {
			memcpy(p + total_recv , buffer , bytes);
			total_recv = total_recv + bytes;
		}

		// printf("%d - %d\n" , bytes , strlen(buffer));

		if(bytes == SOCKET_ERROR) {
			delete(p);
			printf("接收数据失败!\n");
			return 0;
		}

		if( total_recv >= length || bytes == 0    /* || (bytes < buffer_len && buffer[bytes - 1] == 0x00 ) */ ) {
			memcpy(buf , p , total_recv);
			delete(p);

			// printf("total length: %d" , total_recv);
			// printf("接收数据完成!\n");
			return total_recv;
		}
	}
	return 0;
}


// 关闭链接
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

/*
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
*/


