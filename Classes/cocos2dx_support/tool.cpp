#include "tool.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
USING_NS_CC;

extern "C"{
	//c++����androidԭ�������
	void showInput(){
		#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
			JniMethodInfo t;
			if(JniHelper::getStaticMethodInfo(t, "com/game/suitang/Suitang", "showInputDlg", "()V")){
				CCLog("Ҳһ���ҵ�");
				t.env->CallStaticVoidMethod(t.classID, t.methodID);
			}
		#else
			CCLog("no effect function");
		#endif
	}

	const char* getFileFullPath(const char* fileName){
		return CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(fileName);
	}

	//c++����lua�ĺ���
	void callLuaFunc(const char* fileName, const char* funcName, const char* msg){
		lua_State* ls = CCLuaEngine::defaultEngine()->getLuaState();
		CCLog("this function is in ");
		CCLog("%s-------%s--------%s-----------%s",fileName, funcName, msg, getFileFullPath(fileName));

		lua_getglobal(ls, funcName);       /* query function by name, stack: function */
	    if (!lua_isfunction(ls, -1))
	    {
	        CCLOG("[LUA ERROR] name '%s' does not represent a Lua function", funcName);
	        lua_pop(ls, 1);
		    return;
	    }

		lua_pushstring(ls, msg);
		int error = lua_pcall(ls, 1, 0, 0);

		if (error)
		{
			CCLOG("[LUA ERROR] %s", lua_tostring(ls, - 1));
			lua_pop(ls, 1); // clean error message
			return;
		}
	}

	//������ú�������lua�е���
	void luaCallback(int type){
		switch(type){
			case 0:  //0�ǵ��������
				showInput();	
			break;
		}
	}

	char* jstr2Char(JNIEnv *env,jstring str){
		char* result = NULL;
		jclass clsString = env->FindClass("java/lang/String");
		jstring strencode = env->NewStringUTF("utf8");
		jmethodID mid = env->GetMethodID(clsString, "getBytes", "(Ljava/lang/String;)[B");
		jbyteArray barry = (jbyteArray)env->CallObjectMethod(str, mid, strencode);
		jsize len = env->GetArrayLength(barry);
		jbyte* ba = env->GetByteArrayElements(barry, JNI_FALSE);

		if(len > 0 ){
			result = (char*)malloc(len + 1);
			memcpy(result,ba,len);
			result[len] = 0;
		}
		env->ReleaseByteArrayElements(barry, ba, 0);

		return result;
	}

	//jstring str2jstring(JNIEnv* env,const char* pat)

	//{

	//	//����java String�� strClass

	//	jclass strClass = (env)->FindClass("Ljava/lang/String;");

	//	//��ȡString(byte[],String)�Ĺ�����,���ڽ�����byte[]����ת��Ϊһ����String

	//	jmethodID ctorID = (env)->GetMethodID(strClass, "<init>", "([BLjava/lang/String;)V");

	//	//����byte����

	//	jbyteArray bytes = (env)->NewByteArray(strlen(pat));

	//	//��char* ת��Ϊbyte����

	//	(env)->SetByteArrayRegion(bytes, 0, strlen(pat), (jbyte*)pat);

	//	// ����String, ������������,����byte����ת����Stringʱ�Ĳ���

	//	jstring encoding = (env)->NewStringUTF("GB2312"); 

	//	//��byte����ת��Ϊjava String,�����

	//	return (jstring)(env)->NewObject(strClass, ctorID, bytes, encoding);

	//}
};



