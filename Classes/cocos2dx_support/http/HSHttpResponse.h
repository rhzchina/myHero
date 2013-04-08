/********************************************************************
  *  Copyright(C) 2012 Ambition( All rights reserved. )
  *    Created:    2012/09/20   9:42
  *    File base:    HSHttpResponse.h
  *    Author:        Ambition
  *    
  *    Purpose:    响应包含返回的具体数据，但是没有解析
 *********************************************************************/
 #ifndef __HSHttpResponse_H__
 #define __HSHttpResponse_H__
 #pragma once
 #include "HSHttpRequest.h"
 
 
 class HSHttpResponse : public CCObject
 {
 public:
     HSHttpResponse(HSHttpRequest* request);
     virtual ~HSHttpResponse(void);
 
 protected:
     HSHttpRequest*    pHttpRequest;    //对应的请求指针
     bool            isSucceed;        //是否成功
     vector<char>    vResponseData;    
     int                iResponseCode;    //响应代码
     string            strErrorBuffer;    //错误信息缓存
 
 public:
     HSHttpRequest* GetHttpRequest();
 
     void SetResponseData(std::vector<char>* data);
     vector<char>* GetResponseData();
 
     void SetResponseCode(int value);
     int GetResponseCode();
 
     void SetSucceed(bool value);
     bool GetSucceed();
 
     void SetErrorBuffer(const char* value);
     const char* GetErrorBuffer();
 
 };
 
 #endif // __HSHttpResponse_H__