#include "ODSocket.h"
#include <vector>

 #include "cocos2d.h"
#include "cocos-ext.h"
 USING_NS_CC;
 USING_NS_CC_EXT;
using namespace std;
class LuaSocket: public CCObject
{
public:
	ODSocket *cSocket;
public:
	static LuaSocket* getInstance();
	LuaSocket(void);
	~LuaSocket(void);
	void openSocket(const char *ip,int poush);//打开socket服务器
	void sendSocket(const char *ch);//发送服务器
	char* getSocket();//从服务器获得数据
	void closeSocket();//关闭服务器
};

