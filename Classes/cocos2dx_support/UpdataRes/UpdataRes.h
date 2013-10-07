#pragma once
#include "cocos2d.h"
#include "CCLuaEngine.h"
using namespace cocos2d;
USING_NS_CC;
class UpdataRes: public CCObject
{
public:
	int callbackHandler ;
public:
	static class UpdataRes *getInstance();
	void  openUrl(const char* url);
	void loadDown(const char *url,const char *path,const char *name,LUA_FUNCTION _logout_callback);
	int loadSchedule();
	int get_type();
	int get_copy();
	void copydata(const char *assets,const char *sdcard , int callbackHandler);
	void deleData(const char *str,const char *bools);
	int get_dele();
	char * DeviceId();
	void play(const char *order_form,const char *price,const char * pass_type,const char *num_value,const char *url );
	UpdataRes(void);
	~UpdataRes(void);
};

