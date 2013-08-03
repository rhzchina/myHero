#include "tool.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
USING_NS_CC;

extern "C"{
	//c++调用android原生输入框
	void showInput(){
		#if(CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
			JniMethodInfo t;
			if(JniHelper::getStaticMethodInfo(t, "com/game/suitang/Suitang", "showInputDlg", "()V")){
				CCLog("也一样找到");
				t.env->CallStaticVoidMethod(t.classID, t.methodID);
			}
		#else
			CCLog("no effect function");
		#endif
	}

	const char* getFileFullPath(const char* fileName){
		return CCFileUtils::sharedFileUtils()->fullPathFromRelativePath(fileName);
	}

	//c++调用lua的函数
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

	//特殊调用函数，在lua中调用
	void luaCallback(int type){
		switch(type){
			case 0:  //0是弹出输入框
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

	//	//定义java String类 strClass

	//	jclass strClass = (env)->FindClass("Ljava/lang/String;");

	//	//获取String(byte[],String)的构造器,用于将本地byte[]数组转换为一个新String

	//	jmethodID ctorID = (env)->GetMethodID(strClass, "<init>", "([BLjava/lang/String;)V");

	//	//建立byte数组

	//	jbyteArray bytes = (env)->NewByteArray(strlen(pat));

	//	//将char* 转换为byte数组

	//	(env)->SetByteArrayRegion(bytes, 0, strlen(pat), (jbyte*)pat);

	//	// 设置String, 保存语言类型,用于byte数组转换至String时的参数

	//	jstring encoding = (env)->NewStringUTF("GB2312"); 

	//	//将byte数组转换为java String,并输出

	//	return (jstring)(env)->NewObject(strClass, ctorID, bytes, encoding);

	//}
};



