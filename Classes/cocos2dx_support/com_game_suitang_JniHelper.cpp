#include "com_game_suitang_JniHelper.h"
#include <jni.h>
#include "cocos2d.h"
#include "CCLuaEngine.h"
USING_NS_CC;

JNIEXPORT void JNICALL Java_com_game_suitang_JniHelper_callToRefresh
	(JNIEnv *env, jclass clazz, jint percent){

	lua_State*  ls = CCLuaEngine::defaultEngine()->getLuaState(); 
	lua_getglobal(ls, "refreshCopy");
	lua_pushnumber(ls, percent);


	int err = lua_pcall(ls, 1, 0, 0);
	if(err){
		CCLog("++++++++++++++++++++++++++++++++++++++++");
		CCLog("%s",lua_tostring(ls, -1));
		CCLog("++++++++++++++++++++++++++++++++++++++++");
	}

	lua_pop(ls, 1);
	CCLog("-------------------------------success-------------------------------");
}
