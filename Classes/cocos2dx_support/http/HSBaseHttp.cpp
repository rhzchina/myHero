#include "HSBaseHttp.h"

 
 //static member
 
 static HSBaseHttp* s_pBaseHttp = NULL; // pointer to singleton
 
  static std::vector<char> *buff;
 
 //线程锁

 static pthread_t        s_networkThread;

 static pthread_mutex_t  s_requestQueueMutex;

 static pthread_mutex_t  s_responseQueueMutex;

 static sem_t *          s_pSem = NULL;

 static unsigned long    s_asyncRequestCount = 0;

 
 static bool need_quit = false;

 static CCArray* s_requestQueue = NULL;        //请求队列

 static CCArray* s_responseQueue = NULL;        //响应队列
 
 #if CC_TARGET_PLATFORM == CC_PLATFORM_IOS
 #define CC_ASYNC_HTTPREQUEST_USE_NAMED_SEMAPHORE 1
 #else
 #define CC_ASYNC_HTTPREQUEST_USE_NAMED_SEMAPHORE 0
 #endif
 
 #if CC_ASYNC_HTTPREQUEST_USE_NAMED_SEMAPHORE
 #define CC_ASYNC_HTTPREQUEST_SEMAPHORE "ccHttpAsync"
 #else
 static sem_t s_sem;
 #endif
 
 #if (CC_TARGET_PLATFORM == CC_PLATFORM_WIN32)
 typedef int int32_t;
 #endif
 
 static char s_errorBuffer[CURL_ERROR_SIZE];
 
 typedef size_t (*write_callback)(void *ptr, size_t size, size_t nmemb, void *stream);
 
 //////////////////////////////////////////////////////////////////////////
 // C 函数实现
 //////////////////////////////////////////////////////////////////////////
 
 size_t writeData(void *ptr, size_t size, size_t nmemb, void *stream)
 {
	// std::vector<char> *recvBuffer = (std::vector<char>*)stream;
	buff = (std::vector<char>*)stream;
	size_t sizes = size * nmemb;
	
	// buff->clear();
	// buff->assign((char*)ptr, (char*)ptr + sizes);
	buff->insert( buff->end() , (char*)ptr , (char*)ptr + sizes );
	// recvBuffer->clear();
	// recvBuffer->assign((char*)ptr, (char*)ptr + sizes);
	CCLog("%s\n",(char*)ptr);
 
	return sizes;
 }
 
 bool ConfigureCURL(CURL *handle)
 {
     if (!handle) {
         return false;
     }
 
     int32_t code;
     code = curl_easy_setopt(handle, CURLOPT_ERRORBUFFER, s_errorBuffer);
     if (code != CURLE_OK) {
         return false;
     }
     //设置超时时间 防止一直等待
     code = curl_easy_setopt(handle, CURLOPT_TIMEOUT, HSBaseHttp::GetInstance()->GetTimeoutForRead());
     if (code != CURLE_OK) {
         return false;
     }
     code = curl_easy_setopt(handle, CURLOPT_CONNECTTIMEOUT, HSBaseHttp::GetInstance()->GetTimeoutForConnect());
     if (code != CURLE_OK) {
         return false;
     }
 
     return true;
 }
 
 //Post 模式设置
 int ProcessPostTask(HSHttpRequest *request, write_callback callback, void *stream, int32_t *responseCode)
 {
     CURLcode code = CURL_LAST;
     CURL *curl = curl_easy_init();
 
     do {
         if (!ConfigureCURL(curl)) {
             break;
         }
 
         code = curl_easy_setopt(curl, CURLOPT_URL, request->GetUrl());
         if (code != CURLE_OK) {
             break;
         }
         code = curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callback);
         if (code != CURLE_OK) {
             break;
         }
         code = curl_easy_setopt(curl, CURLOPT_WRITEDATA, stream);
         if (code != CURLE_OK) {
             break;
         }
         code = curl_easy_setopt(curl, CURLOPT_POST, 1);
         if (code != CURLE_OK) {
             break;
         }

		 /*
		 code = curl_easy_setopt(curl, CURLOPT_ACCEPT_ENCODING, "gzip");
		 if (code != CURLE_OK) {
			 break;
		 }
		 */

         code = curl_easy_setopt(curl, CURLOPT_POSTFIELDS, request->GetRequestData());
         if (code != CURLE_OK) {
             break;
         }
         code = curl_easy_setopt(curl, CURLOPT_POSTFIELDSIZE, request->GetRequestDataSize());
         if (code != CURLE_OK) {
             break;
         }
         code = curl_easy_perform(curl);
         if (code != CURLE_OK) {
             break;
         }
 
         code = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, responseCode); 
         if (code != CURLE_OK || *responseCode != 200) {
             code = CURLE_HTTP_RETURNED_ERROR;
         }
     } while (0);
     if (curl) {
         curl_easy_cleanup(curl);
     }
 
     return (code == CURLE_OK ? 0 : 1);    
 }
 
 //Get模式设置
 int ProcessGetTask(HSHttpRequest *request, write_callback callback, void *stream, int *responseCode)
 {
     CURLcode code = CURL_LAST;
     CURL *curl = curl_easy_init();
 
     do {
         if (!ConfigureCURL(curl)) 
         {
             break;
         }
 
         code = curl_easy_setopt(curl, CURLOPT_URL, request->GetUrl());
         if (code != CURLE_OK) 
         {
             break;
         }
 
         code = curl_easy_setopt(curl, CURLOPT_WRITEFUNCTION, callback);
         if (code != CURLE_OK) 
         {
             break;
         }
 
         code = curl_easy_setopt(curl, CURLOPT_WRITEDATA, stream);
         if (code != CURLE_OK) 
         {
             break;
         }
 
         code = curl_easy_perform(curl);
         if (code != CURLE_OK) 
         {
             break;
         }
 
         code = curl_easy_getinfo(curl, CURLINFO_RESPONSE_CODE, responseCode); 
         if (code != CURLE_OK || *responseCode != 200) 
         {
             code = CURLE_HTTP_RETURNED_ERROR;
         }
     } while (0);
 
     if (curl) {
         curl_easy_cleanup(curl);
     }
 
     return (code == CURLE_OK ? 0 : 1);
 }
 
 
 static void* NetworkThread(void *data)
 {    
     HSHttpRequest *request = NULL;
 
     while (true) 
     {
         // Wait for http request tasks from main thread
         int semWaitRet = sem_wait(s_pSem);
         if (semWaitRet < 0) {
             CCLog("HSBaseHttp: HttpRequest async thread semaphore error: %s\n", strerror(errno));
             break;
         }
 
         if (need_quit)
         {
             break;
         }
 
         // step 1: send http request if the requestQueue isn't empty
         request = NULL;
 
         pthread_mutex_lock(&s_requestQueueMutex); //Get request task from queue
         if (0 != s_requestQueue->count())
         {
             request = dynamic_cast<HSHttpRequest*>(s_requestQueue->objectAtIndex(0));
             s_requestQueue->removeObjectAtIndex(0);  
             // request's refcount = 1 here
         }
         pthread_mutex_unlock(&s_requestQueueMutex);
 
         if (NULL == request)
         {
             continue;
         }
 
         // step 2: libcurl sync access
 
         // Create a HttpResponse object, the default setting is http access failed
         HSHttpResponse *response = new HSHttpResponse(request);
 
         // request's refcount = 2 here, it's retained by HttpRespose constructor
         request->release();
         // ok, refcount = 1 now, only HttpResponse hold it.
 
         int responseCode = -1;
         int retValue = 0;
 
         // Process the request -> get response packet
         switch (request->GetRequestType())
         {
         case HTTP_MODE_GET: // HTTP GET
             retValue = ProcessGetTask(request,     writeData,     response->GetResponseData(), &responseCode);
             break;
 
         case HTTP_MODE_POST: // HTTP POST
             retValue = ProcessPostTask(request, writeData,     response->GetResponseData(), &responseCode);
             break;
 
         default:
             CCAssert(true, "CCHttpClient: unkown request type, only GET and POSt are supported");
             break;
         }
 
         // write data to HttpResponse
         response->SetResponseCode(responseCode);
 
         if (retValue != 0) 
         {
             response->SetSucceed(false);
             response->SetErrorBuffer(s_errorBuffer);
         }
         else
         {
             response->SetSucceed(true);
         }
 
 
         // add response packet into queue
         pthread_mutex_lock(&s_responseQueueMutex);
         s_responseQueue->addObject(response);
         pthread_mutex_unlock(&s_responseQueueMutex);
 
         // resume dispatcher selector
        // CCScheduler::CCScheduler()->resumeTarget(HSBaseHttp::GetInstance());
		  CCDirector::sharedDirector()->getScheduler()->resumeTarget(HSBaseHttp::GetInstance());
     }
 
     // cleanup: if worker thread received quit signal, clean up un-completed request queue
     pthread_mutex_lock(&s_requestQueueMutex);
     s_requestQueue->removeAllObjects();
     pthread_mutex_unlock(&s_requestQueueMutex);
     s_asyncRequestCount -= s_requestQueue->count();
 
     if (s_pSem != NULL) {
 #if CC_ASYNC_HTTPREQUEST_USE_NAMED_SEMAPHORE
         sem_unlink(CC_ASYNC_HTTPREQUEST_SEMAPHORE);
         sem_close(s_pSem);
 #else
         sem_destroy(s_pSem);
 #endif
 
         s_pSem = NULL;
 
         pthread_mutex_destroy(&s_requestQueueMutex);
         pthread_mutex_destroy(&s_responseQueueMutex);
 
         s_requestQueue->release();
         s_responseQueue->release();
     }
 
     pthread_exit(NULL);
 
     return 0;
 }
 
 HSBaseHttp::HSBaseHttp()
 {
     this->iTimeoutForConnect = 5;
     this->iTimeoutForRead = 10;
    CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector(HSBaseHttp::DispatchResponseCallbacks), this, 0, false);
     CCDirector::sharedDirector()->getScheduler()->pauseTarget(this);
 }
 
 HSBaseHttp::~HSBaseHttp()
 {
     need_quit = true;
 
     if (s_pSem != NULL) 
     {
         sem_post(s_pSem);
     }
     CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(HSBaseHttp::DispatchResponseCallbacks), this);
 }
 
 HSBaseHttp* HSBaseHttp::GetInstance()
 {
     if (s_pBaseHttp == NULL)
     {
         s_pBaseHttp = new HSBaseHttp();
     }
 
     return s_pBaseHttp;
 }
 
 void HSBaseHttp::DestroyInstance()
 {
     CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(HSBaseHttp::DispatchResponseCallbacks),HSBaseHttp::GetInstance());
     CC_SAFE_RELEASE_NULL(s_pBaseHttp);
 }
 
 void HSBaseHttp::DispatchResponseCallbacks(float delta)
 {
     HSHttpResponse* response = NULL;
 
     pthread_mutex_lock(&s_responseQueueMutex);
     if (s_responseQueue->count())
     {
         response = dynamic_cast<HSHttpResponse*>(s_responseQueue->objectAtIndex(0));
         s_responseQueue->removeObjectAtIndex(0);
     }
     pthread_mutex_unlock(&s_responseQueueMutex);
 
     if (response)
     {
         --s_asyncRequestCount;
 
         HSHttpRequest* request = response->GetHttpRequest();
         CCObject* pTarget = request->GetTarget();
         SEL_CallFuncND pSelector = request->GetSelector();
 
         if (pTarget && pSelector) 
         {
             (pTarget->*pSelector)((CCNode *)this, response);
         }
 
         response->release();
     }

	if (buff != NULL && buff->size()>0) {
		buff->clear();
	}

     if (0 == s_asyncRequestCount) 
     {
        CCDirector::sharedDirector()->getScheduler()->pauseTarget(this);
     }

	 // 退出进程
	 //need_quit = true;
 }
 
 bool HSBaseHttp::LazyInitThreadSemphore()
 {
     //if(s_pSem != NULL)
     //    return false;
 
 #if CC_ASYNC_HTTPREQUEST_USE_NAMED_SEMAPHORE
     s_pSem = sem_open(CC_ASYNC_HTTPREQUEST_SEMAPHORE, O_CREAT, 0644, 0);
     if (s_pSem == SEM_FAILED) {
         CCLog("Open HttpRequest Semaphore failed");
         s_pSem = NULL;
         return false;
     }
 #else
     int semRet = sem_init(&s_sem, 0, 0);
     if (semRet < 0) {
         CCLog("Init HttpRequest Semaphore failed");
         return false;
     }
 
     s_pSem = &s_sem;
 #endif
 
     s_requestQueue = CCArray::array();
     s_requestQueue->init();
     s_requestQueue->retain();
 
     s_responseQueue = CCArray::array();    
     s_responseQueue->init();
     s_responseQueue->retain();
 
     pthread_mutex_init(&s_requestQueueMutex, NULL);
     pthread_mutex_init(&s_responseQueueMutex, NULL);
 
	// 创建线程
     pthread_create(&s_networkThread, NULL, NetworkThread, NULL);
     pthread_detach(s_networkThread);
 
     need_quit = false;
 
     return true;
 
 }
 
 void HSBaseHttp::Send(HSHttpRequest* request)
 {
     if (!LazyInitThreadSemphore() || !request) 
     {
         return;
     }
 
     ++s_asyncRequestCount;
 
     request->retain();
 
     pthread_mutex_lock(&s_requestQueueMutex);
     s_requestQueue->addObject(request);
     pthread_mutex_unlock(&s_requestQueueMutex);
 
     // Notify thread start to work
     sem_post(s_pSem);
 }
 
 void HSBaseHttp::SetTimeoutForConnect( int value )
 {
     this->iTimeoutForConnect = value;
 }
 
 int HSBaseHttp::GetTimeoutForConnect()
 {
     return this->iTimeoutForConnect;
 }
 
 void HSBaseHttp::SetTimeoutForRead( int value )
 {
     this->iTimeoutForRead = value;
 }
 
 int HSBaseHttp::GetTimeoutForRead()
 {
     return this->iTimeoutForRead;
 }