#ifndef CC_LUA_ENGINE_ENABLED
#define CC_LUA_ENGINE_ENABLED 1
#endif

#ifndef __CC_EXTENSION_CCNETWORK_H_
#define __CC_EXTENSION_CCNETWORK_H_


#include "network/CCHTTPRequest.h"
#include "network/CCHTTPRequestDelegate.h"




#define kCCNetworkStatusNotReachable     0
#define kCCNetworkStatusReachableViaWiFi 1
#define kCCNetworkStatusReachableViaWWAN 2

class CCNetwork : public CCObject
{
public:
#pragma mark -
#pragma mark reachability
    
    /** @brief Checks whether a local wifi connection is available */
    static bool isLocalWiFiAvailable(void);
    
    /** @brief Checks whether the default route is available */
    static bool isInternetConnectionAvailable(void);
    
    /** @brief Checks the reachability of a particular host name */
    static bool isHostNameReachable(const char* hostName);
    
    /** @brief Checks Internet connection reachability status */
    static int getInternetConnectionStatus(void);
    
#pragma mark -
#pragma mark HTTP
    
    static CCHTTPRequest* createHTTPRequest(CCHTTPRequestDelegate* delegate,
                                            const char* url,
                                            int method = kCCHTTPRequestMethodGET);
    
    static CCHTTPRequest* createHTTPRequestLua(int listener,
                                               const char* url,
                                               int method = kCCHTTPRequestMethodGET);
    
private:
    CCNetwork(void) {}
};



#endif // __CC_EXTENSION_CCNETWORK_H_
