#include "HSHttpResponse.h"
 
 HSHttpResponse::HSHttpResponse(HSHttpRequest* request)
 {
     this->pHttpRequest = request;
     if (this->pHttpRequest)
     {
         this->pHttpRequest->retain();
     }
     this->isSucceed = false;
     this->vResponseData.clear();
     this->strErrorBuffer.clear();
 }
 
 HSHttpResponse::~HSHttpResponse(void)
 {
     if (this->pHttpRequest)
     {
         this->pHttpRequest->release();
     }
 }
 
 HSHttpRequest* HSHttpResponse::GetHttpRequest()
 {
     return this->pHttpRequest;
 }
 
 void HSHttpResponse::SetResponseData( std::vector<char>* data )
 {
     vResponseData = *data;
 }
 
 vector<char>* HSHttpResponse::GetResponseData()
 {
     return &vResponseData;
 }
 
 void HSHttpResponse::SetResponseCode( int value )
 {
     iResponseCode = value;
 }
 
 int HSHttpResponse::GetResponseCode()
 {
     return this->iResponseCode;
 }
 
 void HSHttpResponse::SetSucceed( bool value )
 {
     isSucceed = value;
 }
 
 bool HSHttpResponse::GetSucceed()
 {
     return this->isSucceed;
 }
 
 void HSHttpResponse::SetErrorBuffer( const char* value )
 {
     strErrorBuffer.clear();
     strErrorBuffer.assign(value);
 }
 
 const char* HSHttpResponse::GetErrorBuffer()
 {
     return strErrorBuffer.c_str();
 }