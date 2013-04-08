#include "LuaSocket.h"


static LuaSocket *s_pGameHttp = NULL;
LuaSocket::LuaSocket(void)
{
			
}
LuaSocket::~LuaSocket(void)
{
	
}

LuaSocket* LuaSocket::getInstance()
{
	if (s_pGameHttp == NULL) {
		s_pGameHttp = new LuaSocket();
	}
	return s_pGameHttp;
}

//打开网络连接
void LuaSocket::openSocket(const char *ip,int poush){
	cSocket = new ODSocket();
	cSocket->Init();
	cSocket->Create(AF_INET, SOCK_STREAM, 0);
	cSocket->Connect(ip,poush);
}

//发送数据
void LuaSocket::sendSocket(const char *ch){
	//CCLog("%s completed","开始发送socket数据");
	CCLog("%s ","send socket start");
	cSocket->Send(ch,strlen(ch),0);
}

char* LuaSocket::getSocket(){

	char recvBuf[35240] = "\0";
	cSocket->Recv(recvBuf,35240,0);
	//printf("接收socket数据结束!\n");
	//printf(recvBuf);
	CCLog("%s ","get socket data over");
	//CCLog("%f size",strlen(recvBuf));
	return recvBuf;
}

void LuaSocket::closeSocket(){
	cSocket->Close();
	cSocket->Clean();
}
