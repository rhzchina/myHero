#include "cocos2d.h"
#include "CCEGLView.h"
#include "AppDelegate.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"
#include "tool.h"

using namespace CocosDenshion;

USING_NS_CC;

AppDelegate::AppDelegate()
{
}

AppDelegate::~AppDelegate()
{
    SimpleAudioEngine::end();
}

bool AppDelegate::applicationDidFinishLaunching()
{
    // initialize director
    CCDirector *pDirector = CCDirector::sharedDirector();
    pDirector->setOpenGLView(CCEGLView::sharedOpenGLView());
	//auto fit screen
	CCEGLView::sharedOpenGLView()->setDesignResolutionSize(480, 854, kResolutionExactFit);
//	char *Set_Generals = "{\"m\":\"mission\",\"a\":\"excute\",\"command\":\"excute\",\"sid\":\"e2dcf10f38617ab3\",\"uid\":10001,\"server_id\":1,\"data\":{\"map_id\":1,\"mission_id\":1}}";
	
	/*ODSocket cSocket;
	cSocket.Init();
	cSocket.Create(AF_INET,SOCK_STREAM,0);
	cSocket.Connect("211.154.135.186",8991);
	char recvBuf[64] = "\0";
	cSocket.Send(Set_Generals,strlen(Set_Generals),0);
	cSocket.Recv(recvBuf,64,0);
	printf("%s was recived from server!\n",recvBuf);
	cSocket.Close();
	cSocket.Clean();
	
	*/
	//LuaSocket *socket = new LuaSocket();
	//socket->openSocket("211.154.135.186",8991);
	//socket->sendSocket(Set_Generals);
	//char *data = socket->getSocket();
	//CCLog("get data", data);
	//print("get data",socket->getSocket());
    CCLuaEngine* pEngine = CCLuaEngine::defaultEngine();
    CCScriptEngineManager::sharedManager()->setScriptEngine(pEngine);
	std::string dirPath = "GameScript";
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
    CCString* pstrFileContent = CCString::createWithContentsOfFile((dirPath + "/initialization.lua").c_str());
    if (pstrFileContent)
    {
        pEngine->executeString(pstrFileContent->getCString());
    }
#else
    std::string path = CCFileUtils::sharedFileUtils()->fullPathFromRelativePath((dirPath + "/initialization.lua").c_str());
    pEngine->addSearchPath(path.substr(0, path.find_last_of("/")).c_str());
    pEngine->executeScriptFile(path.c_str());
#endif
    return true;
}

// This function will be called when the app is inactive. When comes a phone call,it's be invoked too
void AppDelegate::applicationDidEnterBackground()
{
    CCDirector::sharedDirector()->stopAnimation();

    SimpleAudioEngine::sharedEngine()->pauseBackgroundMusic();
}

// this function will be called when the app is active again
void AppDelegate::applicationWillEnterForeground()
{
    CCDirector::sharedDirector()->startAnimation();

    SimpleAudioEngine::sharedEngine()->resumeBackgroundMusic();
}
