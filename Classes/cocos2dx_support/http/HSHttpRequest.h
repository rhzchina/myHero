/********************************************************************
  *  Copyright(C) 2012 Ambition( All rights reserved. )
  *    Created:    2012/09/20   9:41
  *    File base:    HSHttpRequest.h
  *    Author:        Ambition
  *    
  *    Purpose:    请求消息发送和设置（不是发送的具体数据）
 *********************************************************************/
 #ifndef __HSHttpRequest_H__
 #define __HSHttpRequest_H__
 #pragma once
 #include "cocos2d.h"
#include "cocos-ext.h"
 using namespace std;
 USING_NS_CC;
 USING_NS_CC_EXT;
 typedef enum
 {
	 HTTP_MODE_GET,
	 HTTP_MODE_POST,
	 HTTP_MODE_UNKOWN,
 }HttpRequestType;

 class HSHttpRequest : public CCObject
 {
 public:
     HSHttpRequest(void);
     ~HSHttpRequest(void);
 protected:
	 int mhandler;
     CCObject*    pTarget;
     SEL_CallFuncND        pSelector;        //回调选择器
     HttpRequestType        requestType;    //请求类型
     string                strUrl;
     vector<char>        vRequestData;
     string              tag;
     void*               pUserData;        //用语在请求前添加的标志 例(Ambition:xxxxxx)
	 int             m_nScriptTapHandler;
	// std::vector<char> *data;//存放服务器返回的数据
 public:
	 static HSHttpRequest* getInstance();
     CCObject* GetTarget();
     SEL_CallFuncND GetSelector();
     void SetRequestType(HttpRequestType type);
     HttpRequestType GetRequestType();
 
     void SetUrl(const char* url);
     const char* GetUrl();
 
     void SetRequestData(const char* buffer, unsigned int len);
     char* GetRequestData();
 
     int GetRequestDataSize();
 
     void SetResponseCallback(CCObject* pTarget, cocos2d::SEL_CallFuncND pSelector);  
 
     void SetTag(const char* tag);
     const char* GetTag();
 
     void SetUserData(void* pUserData);
     void* GetUserData();
	 void onHttpRequestCompleted(cocos2d::CCNode *sender, void *data);

	 void creadFuancuan(int handler);
	 //std::vector<char>* getHttp();//取得数据
	 //void setData(std::vector<char> *str_buf);//存放数据
 };
 
 
 #endif // __HSHttpRequest_H__