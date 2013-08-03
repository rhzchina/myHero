#include "com_game_suitang_JniCall.h"
#include "cocos2d.h"
#include "tool.h"
USING_NS_CC;

extern "C"{
	JNIEXPORT void JNICALL Java_com_game_suitang_JniCall_jniOpt
		(JNIEnv *env, jclass clazz, jint type, jstring info){
		CCLog("test t6he function!~ %s",jstr2Char(env, info));	
		int choose = type;
		switch(choose){
		case 0://这里是jAVA 调用C++的方法， 0是发送聊天信息,接受系统输入框传递 的字符串
			callLuaFunc("assets/GameScript/Scene/chat/chatlayer.lua","sendChatMsg", jstr2Char(env, info));	
			break;
		}
	}
}