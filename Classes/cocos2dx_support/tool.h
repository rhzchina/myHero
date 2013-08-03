#ifndef TOOL_H
#define TOOL_H
#include "cocos2d.h"
#include <jni.h>

#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
	#include "platform/android/jni/JniHelper.h"
#endif

USING_NS_CC;

extern "C"{
	#include "lua.h" 
	#include "lualib.h" 
	#include "lauxlib.h" 

	void showInput();
	//特殊调用函数，在lua中调用
	void luaCallback(int type);

	char* jstr2Char(JNIEnv *env, jstring str);

	const char* getFileFullPath(const char*);

	void callLuaFunc(const char* fileName, const char* funcName, const char* info);
}



#endif