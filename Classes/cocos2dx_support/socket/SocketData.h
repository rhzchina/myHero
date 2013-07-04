#ifndef _SOCKETDATA_H_
#define _SOCKETDATA_H_

#include "cocos2d.h"
USING_NS_CC;

using namespace std;


class SocketData : public CCObject{
public:
	SocketData(int code , string buf);
	~SocketData();
	string buf;
	int code;
};

#endif
