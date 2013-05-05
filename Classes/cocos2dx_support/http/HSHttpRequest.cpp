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

		CCScriptEngineManager::sharedManager()->getScriptEngine()->executeFunction(mhandler , statusCode , "");
		return;
	}

	// dump data
	std::vector<char> *buffer = response->getResponseData();
	std::string strBuf("");
	strBuf.clear();
	strBuf.assign(buffer->begin(),buffer->end());
	CCLog("the data size is %d",strBuf.size());

	std::string ungzip_str("");
	bool gzip_ret = false;
	// std::string temp(strBuf.c_str() );
	// char* ungzip_str;
	gzip_ret = this->gzip_decompress(strBuf.c_str() , 
		strBuf.size() , 
		ungzip_str);

	if(!gzip_ret) {
		ungzip_str.clear();
	}
	CCLog("the real data is %d",ungzip_str.size());
	CCScriptEngineManager::sharedManager()->getScriptEngine()->executeFunction(mhandler,statusCode, ungzip_str.c_str());
}

void HSHttpRequest::creadFuancuan(int handler){//创建lua回调函数
	s_pGameHttp-> mhandler = handler;
} 


bool HSHttpRequest::gzip_decompress(const void* pInDate, size_t nSize, std::string& raw_data) 
{ 
	z_stream   zs ; 
	memset(&zs,0,sizeof(zs));
	std::vector<Byte>   temp_buf (8 * 1024) ; 

	bool   bRet = false ; 
	int    nErr = inflateInit2 (&zs, 47) ; 
	if (nErr == Z_OK) 
	{ 
		zs.next_in = (Byte*)const_cast<void*>(pInDate) ; 
		zs.avail_in = (unsigned int)nSize ; 

		for (;;) 
		{ 
			zs.avail_out = (unsigned int)temp_buf.size() ; 
			zs.next_out = &temp_buf[0] ; 

			nErr = inflate (&zs, Z_NO_FLUSH) ; 

			size_t   nWrite = zs.total_out - raw_data.size() ; 
			if (nWrite) 
			{ 
				raw_data.append ((char*)&temp_buf[0], nWrite) ; 
			} 

			if (nErr == Z_STREAM_END) 
			{ 
				bRet = true ; 
				break; 
			} 
			else if (nErr == Z_OK) // continue 
			{ 
			} 
			else 
			{ 
				break; 
			} 
		} 
		inflateEnd (&zs) ; 
	} 
	// assert(bRet) ; 
	return bRet ; 
} 
