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
		case 0://������jAVA ����C++�ķ����� 0�Ƿ���������Ϣ,����ϵͳ����򴫵� ���ַ���
			callLuaFunc("assets/GameScript/Scene/chat/chatlayer.lua","sendChatMsg", jstr2Char(env, info));	
			break;
		}
	}
}