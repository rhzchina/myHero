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
			CCLog("��������е� ��111111111111111111111111");
			callLuaFunc("assets/GameScript/Scene/chat/chatlayer.lua","sendChatMsg", jstr2Char(env, info));	
			CCLog("�ڵ������`222222222222222222");
			break;
		}
	}
}