#include "ODSocket.h"
#include <vector>

#include "cocos2d.h"
#include "cocos-ext.h"

#include <pthread.h>
#include <queue>
#include <semaphore.h>

USING_NS_CC;
USING_NS_CC_EXT;

using namespace std;
class LuaSocket: public CCObject
{
public:
	ODSocket *cSocket;
// protected:
//	 int mhandler;
public:
	static LuaSocket* getInstance();
	LuaSocket(void);
	~LuaSocket(void);
	int openSocket(const char *ip,int poush, const char* type);//��socket������
	void sendSocket(const char *ch);//���ͷ�����
	char* getSocket();//�ӷ������������
	void closeSocket();//�رշ�����
	void creadFuancuan(int handler);
	void callback(float delta);

private:
	// bool LazyInitThreadSemphore();
};

