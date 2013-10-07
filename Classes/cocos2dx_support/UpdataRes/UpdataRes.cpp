#include "UpdataRes.h"
using namespace std;
using namespace cocos2d;
#include "CCLuaEngine.h"
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "platform/android/jni/JniHelper.h"
#include <android/log.h>
#endif

extern "C" {
#include "lualib.h"
#include "lauxlib.h"
#include "tolua_fix.h"
}

static UpdataRes *updata = NULL;

UpdataRes* UpdataRes::getInstance()
{
	if (updata == NULL) {
		updata = new UpdataRes();
	}

	return updata;
}


void UpdataRes::openUrl(const char *url){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 

	JniMethodInfo methodInfo;


	if (!JniHelper::getStaticMethodInfo(methodInfo, "com/game/suitang/Suitang", "openUrl","(Ljava/lang/String;)V"))
	{
		return;
	}else{
		jstring l_stringUrl = methodInfo.env->NewStringUTF(url);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, l_stringUrl);
		methodInfo.env->DeleteLocalRef(methodInfo.classID);
	}

#endif
}


void UpdataRes::loadDown(const char *url,const char *path,const char *name,LUA_FUNCTION _logout_callback){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 

	JniMethodInfo methodInfo;


	if (!JniHelper::getStaticMethodInfo(methodInfo, "com/game/suitang/Suitang", "loadhttp", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"))
	{
		return;
	}else{
		jstring l_stringUrl = methodInfo.env->NewStringUTF(url);
		jstring l_stringpath = methodInfo.env->NewStringUTF(path);
		jstring l_stringname = methodInfo.env->NewStringUTF(name);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, l_stringUrl,l_stringpath,l_stringname);
		methodInfo.env->DeleteLocalRef(methodInfo.classID);
	}
	callbackHandler = _logout_callback;
#endif
}

int UpdataRes::loadSchedule(){
	//æ≤Ã¨∫Ø ˝ æ¿˝3.”–≤Œ ˝£¨”–∑µªÿ÷µ--------------------------------$$--------------------------------
	int values = 0;
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ®
		//≥¢ ‘jint «∑Òƒ‹’˝≥£Ω” ’∑µªÿµƒint÷µ
		JniMethodInfo minfo;//∂®“ÂJni∫Ø ˝–≈œ¢Ω·ππÃÂ
		bool isHave = JniHelper::getStaticMethodInfo(minfo,"com/game/suitang/Suitang","Get_Schedule","()I");
		if (!isHave) {

		}else{
			//µ˜”√¥À∫Ø ˝

			values = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID,823);
		
			/*jint _int ;
			 _int = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID,823);
			JniMethodInfo minfo_ty;

			bool isHave = JniHelper::getStaticMethodInfo(minfo_ty, "com/android/GameLua/GameLua","set_num",  "(I)V");

			if (isHave) {

				minfo_ty.env->CallStaticVoidMethod(minfo_ty.classID, minfo_ty.methodID,_int);

			}*/
		}
	#endif
	return values;
}

char * UpdataRes::DeviceId(){
	char *str = NULL;
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 
	JniMethodInfo minfo;//∂®“ÂJni∫Ø ˝–≈œ¢Ω·ππÃÂ
	bool isHave = JniHelper::getStaticMethodInfo(minfo,  "com/game/suitang/Suitang","get_msi","()Ljava/lang/String;");
	 if (!isHave) { 
		 CCLog("jni:¥À∫Ø ˝≤ª¥Ê‘⁄"); 
	 }else{
		  //CCLog("~~~~~~~~~~~~~111~~~~~~~~~~~");
		  jstring jstr = (jstring)minfo.env->CallStaticObjectMethod (minfo.classID, minfo.methodID);
		 // CCLOG("~~~~~~~~~ %s",jstr );
		 // CCLog("~~~~~~~~~~~~~222~~~~~~~~~~~");
		  char*   rtn   =   NULL;  
		 // CCLog("~~~~~~~~~~~~~333~~~~~~~~~~~");
		  jclass   clsstring   =   minfo.env->FindClass("java/lang/String");  
		 // CCLog("~~~~~~~~~~~~~444~~~~~~~~~~~");
		  jstring   strencode   =   minfo.env->NewStringUTF("GB2312"); 
		 // CCLog("~~~~~~~~~~~~~555~~~~~~~~~~~");
		  jmethodID   mid   =   minfo.env->GetMethodID(clsstring,   "getBytes",   "(Ljava/lang/String;)[B");
		  //CCLog("~~~~~~~~~~~~~666~~~~~~~~~~~");
		  jbyteArray   barr=   (jbyteArray)minfo.env->CallObjectMethod(jstr,mid,strencode);
		  //CCLog("~~~~~~~~~~~~~777~~~~~~~~~~~");
		  jsize   alen   =   minfo.env->GetArrayLength(barr);  
		 // CCLog("~~~~~~~~~~~~~888~~~~~~~~~~~");
		  jbyte*   ba   =   minfo.env->GetByteArrayElements(barr,JNI_FALSE);
		 // CCLog("~~~~~~~~~~~~~999~~~~~~~~~~~");
		  if(alen   >   0)  
		  {  
			 // CCLog("~~~~~~~~~~~~~101~~~~~~~~~~~");
			  rtn   =   (char*)malloc(alen+1);         //new   char[alen+1]; 
			 // CCLog("~~~~~~~~~~~~~102~~~~~~~~~~~");
			  memcpy(rtn,ba,alen); 
			 // CCLog("~~~~~~~~~~~~~103~~~~~~~~~~~");
		      rtn[alen]=0;  
			 // CCLog("~~~~~~~~~~~~~104~~~~~~~~~~~");
		  }  
		  minfo.env->ReleaseByteArrayElements(barr,ba,0); 
		 // CCLog("~~~~~~~~~~~~~105~~~~~~~~~~~");
		  str = rtn;
		 // CCLog("~~~~~~~~~~~~~106~~~~~~~~~~~");
	 }
	#endif 
	return str;
}

int UpdataRes::get_type(){
	int type = 0;
    #if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //жϵǰǷΪAndroidƽ̨
        type = 1;
    #elif(CC_TARGET_PLATFORM==CC_PLATFORM_IOS)
        type = 2;
    #endif
    
	return type;
}

void UpdataRes::copydata(const char *assets,const char *sdcard , int callbackHandler){
	this->callbackHandler = callbackHandler;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 

	JniMethodInfo methodInfo;


	if (!JniHelper::getStaticMethodInfo(methodInfo, "com/game/suitang/Suitang", "copy", "(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		return;
	}else{
		jstring l_stringUrl = methodInfo.env->NewStringUTF(assets);
		jstring l_stringpath = methodInfo.env->NewStringUTF(sdcard);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, l_stringUrl,l_stringpath);
		methodInfo.env->DeleteLocalRef(methodInfo.classID);
	}

#endif

}

void UpdataRes::play(const char *order_form,const char *price,const char * pass_type,const char *num_value ,const char *url){

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 

	JniMethodInfo methodInfo;


	if (!JniHelper::getStaticMethodInfo(methodInfo, "com/game/suitang/Suitang", "pay","(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"))
	{
		return;
	}else{
		jstring l_stringUrl = methodInfo.env->NewStringUTF(order_form);
		jstring l_stringpath = methodInfo.env->NewStringUTF(price);
		jstring l_stringname = methodInfo.env->NewStringUTF(pass_type);
		jstring l_stringnum = methodInfo.env->NewStringUTF(num_value);
		jstring l_stringurl2 = methodInfo.env->NewStringUTF(url);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, l_stringUrl,l_stringpath,l_stringname,l_stringnum,l_stringurl2);
		methodInfo.env->DeleteLocalRef(methodInfo.classID);
	}



	

#endif

}


int UpdataRes::get_copy(){
	
	//CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(UpdataRes::set_bar), this, 0, false);//this->schedule(schedule_selector(UpdataRes::set_bar), 1.0f);
	int values = 0;
	#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ®
		//≥¢ ‘jint «∑Òƒ‹’˝≥£Ω” ’∑µªÿµƒint÷µ
		JniMethodInfo minfo;//∂®“ÂJni∫Ø ˝–≈œ¢Ω·ππÃÂ
		bool isHave = JniHelper::getStaticMethodInfo(minfo,"com/game/suitang/Suitang","get_copy","()I");
		if (!isHave) {

		}else{
			//µ˜”√¥À∫Ø ˝

			values = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID,823);
		}
	#endif
	return values;
}
void UpdataRes::deleData(const char *assets,const char *sdcard){
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ® 

	JniMethodInfo methodInfo;


	if (!JniHelper::getStaticMethodInfo(methodInfo, "com/game/suitang/Suitang", "Dele_Data", "(Ljava/lang/String;Ljava/lang/String;)V"))
	{
		return;
	}else{
		jstring l_stringUrl = methodInfo.env->NewStringUTF(assets);
		jstring l_stringpath = methodInfo.env->NewStringUTF(sdcard);
		methodInfo.env->CallStaticVoidMethod(methodInfo.classID, methodInfo.methodID, l_stringUrl,l_stringpath);
		methodInfo.env->DeleteLocalRef(methodInfo.classID);
	}

#endif
}

int UpdataRes::get_dele(){
	int values = 0;
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID) //≈–∂œµ±«∞ «∑ÒŒ™Android∆ΩÃ®
	//≥¢ ‘jint «∑Òƒ‹’˝≥£Ω” ’∑µªÿµƒint÷µ
	JniMethodInfo minfo;//∂®“ÂJni∫Ø ˝–≈œ¢Ω·ππÃÂ
	bool isHave = JniHelper::getStaticMethodInfo(minfo,"com/game/suitang/Suitang","Get_dele","()I");
	if (!isHave) {

	}else{
		//µ˜”√¥À∫Ø ˝

		values = minfo.env->CallStaticIntMethod(minfo.classID, minfo.methodID,823);
	}
#endif
	return values;
}

UpdataRes::UpdataRes(void)
{
}


UpdataRes::~UpdataRes(void)
{
}
