#ifndef JNI_TEST_H
#define JNI_TEST_H



#include "cocos2d.h"

#include "UpdataRes/UpdataRes.h"

	#include <jni.h>

using namespace cocos2d;


void setloadfile(const char * fly_str){
	CCLog("load file C++ %s",fly_str);
	CCLuaValueDict dict;
	dict["load"]  = CCLuaValue::stringValue("load");
	dict["data"]  = CCLuaValue::stringValue(fly_str);

	CCLuaEngine::defaultEngine()->cleanStack();
	CCLuaEngine::defaultEngine()->pushCCLuaValueDict(dict);
	CCLuaEngine::defaultEngine()->executeFunctionByHandler(UpdataRes::getInstance()->callbackHandler, 1);
}

void exitApp()
{
	CCDirector::sharedDirector()->end();
}

#endif