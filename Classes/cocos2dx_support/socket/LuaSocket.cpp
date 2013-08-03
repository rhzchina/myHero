#include "LuaSocket.h"
#include "SocketData.h"
#include <zlib.h>


static LuaSocket *s_pGameHttp = NULL;
static pthread_t s_sendThread;
static pthread_t s_readThread;
static CCArray* s_requestQueue = NULL;        //请求队列
static CCArray* s_responseQueue = NULL;		  //响应队列
static pthread_mutex_t s_requestQueueMutex;
static pthread_mutex_t s_responseQueueMutex;
static int _mhandler;
// static string buf;
// static int return_code;
static bool need_quit = false;

// static LuaSocketResponse* response;
static bool socket_gzip_decompress(const void* pInDate, size_t nSize, std::string& raw_data) 
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


// 写线程处理
static void* sendThread(void *data)
{
	string ch(((string*)data)->data());
	ODSocket *cSocket = NULL;
	// CCLog("%s" , ch);
	// CCLog("Request String: %s" , ch);


	// 从队列中取出 cSocket 对象

	pthread_mutex_lock(&s_requestQueueMutex);
	if (0 != s_requestQueue->count()) {
		cSocket = (ODSocket *)(s_requestQueue->objectAtIndex(0));
		s_requestQueue->removeObjectAtIndex(0);  
	}
	pthread_mutex_unlock(&s_requestQueueMutex);


	// 发送数据
	//CCLog("%s\n%s" , "SOCKET send begin",ch.data());
	int ret = 0;
	ret = cSocket->Send(ch.data() , ch.size() , 0);
	if(ret < 0) {
		// 出现错误，一般是断网了
		/*
		buf.clear();
		return_code = -101;
		CCDirector::sharedDirector()->getScheduler()->resumeTarget( LuaSocket::getInstance() );
		*/
		// 放入队列，去执行回调
		pthread_mutex_lock(&s_responseQueueMutex);
		s_responseQueue->addObject( new SocketData(-101 , "") );
		pthread_mutex_unlock(&s_responseQueueMutex);
	}

	return 0;
}

// 读线程处理
static void* readThread(void *data)
{
	char *ch = (char *) data;
	ODSocket *cSocket = NULL;

	// CCLog("%s" , ch);
	// CCLog("Request String: %s" , ch);


	// 从队列中取出 cSocket 对象

	pthread_mutex_lock(&s_requestQueueMutex);
	if (0 != s_requestQueue->count()) {
		cSocket = (ODSocket *)(s_requestQueue->objectAtIndex(0));
		s_requestQueue->removeObjectAtIndex(0);  
	}
	pthread_mutex_unlock(&s_requestQueueMutex);

	/*
	// 发送数据
	CCLog("%s" , "SOCKET send begin");
	cSocket->Send(ch , strlen(ch) , 0);
	*/

	string buf;
	int return_code;

	buf.clear();
	while (true) {
		char recvBuf[50000] = "\0";
		int length = 0;
		length = cSocket->Recv(recvBuf , 50000 , 0);

		// 接收数据
		CCLog("total length: %d" , length);
		CCLog("%s" , "SOCKET get data end");

		// 判断服务端已断开
		if(length < 0) {
			need_quit = true;
			
			break;
		}

		// 解压缩
		buf.clear();

		bool gzip_ret = false;
		std::string ungzip_str("");
		gzip_ret = socket_gzip_decompress(
			recvBuf , 
			length , 
			buf
			);

		if(!gzip_ret) {
			ungzip_str.clear();
		}

		string buf_prefix = buf.substr(0 , 30);
		buf_prefix.erase(0 , buf_prefix.find_first_not_of(" "));

		return_code = 200;
		if(buf_prefix == "kick_off") {
			return_code = -99;
		}

		// 放入队列，去执行回调
		pthread_mutex_lock(&s_responseQueueMutex);
		s_responseQueue->addObject( new SocketData(return_code , buf) );
		pthread_mutex_unlock(&s_responseQueueMutex);

		//CCDirector::sharedDirector()->getScheduler()->resumeTarget( LuaSocket::getInstance() );
	}

	
	// 出现错误，一般是断网了
	// 放入队列，去执行回调
	pthread_mutex_lock(&s_responseQueueMutex);
	s_responseQueue->addObject( new SocketData(-100 , "") );
	pthread_mutex_unlock(&s_responseQueueMutex);
	/*
	if(return_code >= 0) {
		return_code = -100;
		CCDirector::sharedDirector()->getScheduler()->resumeTarget( LuaSocket::getInstance() );
	}
	*/

	return 0;
}

void LuaSocket::callback(float delta) {
	pthread_mutex_lock(&s_responseQueueMutex);
	if (0 != s_responseQueue->count()) {
		SocketData * data = (SocketData *)(s_responseQueue->objectAtIndex(0));
		s_responseQueue->removeObjectAtIndex(0);  

		CCScriptEngineManager::sharedManager()->getScriptEngine()->executeFunction(_mhandler , data->code , data->buf.data());
	}
	pthread_mutex_unlock(&s_responseQueueMutex);


	// 回调lua的函数
	/*
	CCScriptEngineManager::sharedManager()->getScriptEngine()->executeFunction(_mhandler , data->code ,buf.data());

	if(need_quit == false) {
		CCDirector::sharedDirector()->getScheduler()->pauseTarget(LuaSocket::getInstance());
	} else {
		CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector(LuaSocket::callback),LuaSocket::getInstance());
		need_quit = false;

		s_pGameHttp->closeSocket();
		s_pGameHttp = NULL;
	}
	*/

	
}

LuaSocket::LuaSocket(void)
{
			
}
LuaSocket::~LuaSocket(void)
{
	
}

LuaSocket* LuaSocket::getInstance()
{
	if (s_pGameHttp == NULL) {
		s_pGameHttp = new LuaSocket();
	}
	return s_pGameHttp;
}

// 打开网络连接
int LuaSocket::openSocket(const char *ip , int poush, const char* type) {
	cSocket = new ODSocket();
	cSocket->Init();
	cSocket->Create(AF_INET , SOCK_STREAM , 0);

	int ret = 0;
	ret = cSocket->Connect(ip , poush, type);
	if( ret == 0 ) {
		return -1;
	}


	// 设置回调函数
	CCDirector::sharedDirector()->getScheduler()->unscheduleSelector(schedule_selector( LuaSocket::callback ) , s_pGameHttp);
	CCDirector::sharedDirector()->getScheduler()->scheduleSelector(schedule_selector( LuaSocket::callback ) , s_pGameHttp , 0.02f , false);
	// CCDirector::sharedDirector()->getScheduler()->pauseTarget(s_pGameHttp);


	// 创建消息队列，传递数据
	s_requestQueue = CCArray::array();
	s_requestQueue->init();
	s_requestQueue->retain();

	s_responseQueue = CCArray::array();    
	s_responseQueue->init();
	s_responseQueue->retain();


	pthread_mutex_init(&s_requestQueueMutex, NULL);
	pthread_mutex_init(&s_responseQueueMutex, NULL);

	pthread_mutex_lock(&s_requestQueueMutex);
	s_requestQueue->addObject( (CCObject *)cSocket );
	pthread_mutex_unlock(&s_requestQueueMutex);

	// 创建写线程
	pthread_create(&s_readThread , NULL , readThread , NULL);

	// 设置主进程不等待，不阻塞
	pthread_detach(s_readThread);


	return 0;
}



// 发送数据
void LuaSocket::sendSocket(const char *ch) {
	// CCLog("%s completed","开始发送socket数据");
	/*
	CCLog("%s" , "send socket start");
	cSocket->Send(ch , strlen(ch) , 0);
	*/


	CCLog("%s" , "create thread start");

	pthread_mutex_init(&s_requestQueueMutex, NULL);
	pthread_mutex_init(&s_responseQueueMutex, NULL);

	pthread_mutex_lock(&s_requestQueueMutex);
	s_requestQueue->addObject( (CCObject *)cSocket );
	pthread_mutex_unlock(&s_requestQueueMutex);
	
	// 创建写线程
	string* str = new string(ch);
	pthread_create(&s_sendThread , NULL , sendThread ,(void*)str);

	// 设置主进程不等待，不阻塞
	pthread_detach(s_sendThread);
}


// 获取数据
char* LuaSocket::getSocket() {

	char recvBuf[35240] = "\0";
	cSocket->Recv(recvBuf , 35240 , 0);
	//printf("接收socket数据结束!\n");
	//printf(recvBuf);
	CCLog("%s" , "get socket data over");
	//CCLog("%f size",strlen(recvBuf));
	return recvBuf;
}

// 关闭链接
void LuaSocket::closeSocket(){
	cSocket->Close();
	cSocket->Clean();
}


// 回调函数
void LuaSocket::creadFuancuan(int handler){
	_mhandler = handler;
}



