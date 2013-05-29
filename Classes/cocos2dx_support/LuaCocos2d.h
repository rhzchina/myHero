
#ifndef __LUACOCOS2D_H_
#define __LUACOCOS2D_H_

/******************add socket**********************/
#include "LuaSocket.h"
#include "AnimatePacker/AnimatePacker.h"
//#include "Singleton.h"


extern "C" {
#include "tolua++.h"
#include "tolua_fix.h"
}

#include <map>
#include <string>
#include "tolua_fix.h"
#include "cocos2d.h"
#include "CCLuaEngine.h"
#include "SimpleAudioEngine.h"

using namespace cocos2d;
using namespace CocosDenshion;

TOLUA_API int tolua_Cocos2d_open(lua_State* tolua_S);

#endif // __LUACOCOS2D_H_
