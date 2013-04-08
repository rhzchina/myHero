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
