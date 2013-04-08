#include "HSHttpRequest.h"
 
static HSHttpRequest *s_pGameHttp = NULL;

HSHttpRequest* HSHttpRequest::getInstance()
{
	s_pGameHttp = NULL;
	// if (s_pGameHttp == NULL) {
		s_pGameHttp = new HSHttpRequest();
	// }

	return s_pGameHttp;
}

 HSHttpRequest::HSHttpRequest(void)
 {
	this->requestType = HTTP_MODE_UNKOWN;
	this->vRequestData.clear();
	this->tag.clear();
	this->pTarget = NULL;
	this->pSelector = NULL;
	this->pUserData = NULL;

	// this->data = NULL;
	// this->is_get_over = false;
 }
 
 HSHttpRequest::~HSHttpRequest(void)
 {
 }
 
 CCObject* HSHttpRequest::GetTarget()
 {
     return this->pTarget;
 }
 
 cocos2d::SEL_CallFuncND HSHttpRequest::GetSelector()
 {
     return pSelector;
 }
 
HttpRequestType HSHttpRequest::GetRequestType()
 {
     return this->requestType;
 }
 
 void HSHttpRequest::SetUrl( const char* url )
 {
     strUrl = url;
 }
 
 const char* HSHttpRequest::GetUrl()
 {
     return strUrl.c_str();
 }
 
 void HSHttpRequest::SetRequestData( const char* buffer, unsigned int len )
 {
     vRequestData.assign(buffer, buffer + len);
	 SetResponseCallback(this, callfuncND_selector(HSHttpRequest::onHttpRequestCompleted));
 }
 
 char* HSHttpRequest::GetRequestData()
 {
     return &(vRequestData.front());
 }
 
 int HSHttpRequest::GetRequestDataSize()
 {
     return vRequestData.size();
 }
 
 void HSHttpRequest::SetRequestType( HttpRequestType type )
 {
     requestType = type;
	 //SetResponseCallback(this, callfuncND_selector(HSHttpRequest::onHttpRequestCompleted));
 }
 
 void HSHttpRequest::SetResponseCallback( CCObject* pTarget, cocos2d::SEL_CallFuncND pSelector )
 {
     this->pTarget = pTarget;
     this->pSelector = pSelector;
 
     if (this->pTarget)
     {
         //this->pTarget->retain();
         //如果有问题以后修改
     }
 }
 
 void HSHttpRequest::SetTag( const char* tag )
 {
     this->tag = tag;
 }
 
 const char* HSHttpRequest::GetTag()
 {
     return this->tag.c_str();
 }
 
 void HSHttpRequest::SetUserData( void* pUserData )
 {
     this->pUserData = pUserData;
 }
 
 void* HSHttpRequest::GetUserData()
 {
     return this->pUserData;
 }

 void HSHttpRequest::onHttpRequestCompleted(cocos2d::CCNode *sender, void *data)
 {
	 CCHttpResponse *response = (CCHttpResponse*)data;

	 if (!response)
	 {
		 return;
	 }

	 // You can get original request type from: response->request->reqType
	 if (0 != strlen(response->getHttpRequest()->getTag())) 
	 {
		 // CCLog("%s completed", response->getHttpRequest()->getTag());
	 }

	 int statusCode = response->getResponseCode();
	 char statusString[64] = {};
	 //sprintf(statusString, "HTTP Status Code: %d, tag = %s", statusCode, response->getHttpRequest()->getTag());
	// m_labelStatusCode->setString(statusString);
	 // CCLog("response code: %d", statusCode);

	 if (!response->isSucceed()) 
	 {
		 CCLog("response failed");
		 CCLog("error buffer: %s", response->getErrorBuffer());
		 return;
	 }

	 // dump data
	 std::vector<char> *buffer = response->getResponseData();
	 std::string strBuf("");
	 strBuf.clear();
	 strBuf.assign(buffer->begin(),buffer->end());
	CCScriptEngineManager::sharedManager()->getScriptEngine()->executeFunction(mhandler,statusCode, strBuf.c_str());
 }
 
 void HSHttpRequest::creadFuancuan(int handler){//创建lua回调函数
		s_pGameHttp-> mhandler = handler;
 } 