/********************************************************************
  
*  Copyright(C) 2012 Ambition( All rights reserved. )
  
*    Created:    2012/09/18   11:21
 
*    File base:    HSBaseHttp.h
  
*    Author:        Ambition
  
*    
  
*    Purpose:    
 
*********************************************************************/
 
#ifndef __HSBaseHttp_H__
 
#define __HSBaseHttp_H__
 
#pragma once
 
#include "cocos2d.h"
 
//#include "curl.h"
#include "curl/curl.h"
#include <queue>
 
#include <pthread.h>
 
#include <semaphore.h>
 
#include <errno.h>
 
#include "HSHttpRequest.h"
 
#include "HSHttpResponse.h"

using namespace cocos2d;
 
 
#if WIN32
 
#pragma comment(lib,"libcurl_imp.lib")

 #pragma comment(lib,"pthreadVCE2.lib")
 
#endif
 
 
 
class HSBaseHttp : public CCObject
 {

 
 public:
     HSBaseHttp();

     virtual ~HSBaseHttp();

 
 private:
     int iTimeoutForConnect;        //链接超时时间
	  
     int iTimeoutForRead;        //读取超时时间

 public:
     //得到一个实例

     static HSBaseHttp* GetInstance();
     //销毁实例

     static void DestroyInstance();
     //发送请求

     void Send(HSHttpRequest* request);

     void SetTimeoutForConnect(int value);

     
int GetTimeoutForConnect();

  
   void SetTimeoutForRead(int value);

 
    int GetTimeoutForRead();

 private:
     
     //销毁回调

     void DispatchResponseCallbacks(float delta);

     //线程信号初始化

     bool LazyInitThreadSemphore();

 };

 
#endif 
// __HSBaseHttp_H__