#include "CTSearchButton.h"
USING_NS_CC;
USING_NS_CC_EXT;


CTSearchButton* CTSearchButton::createCTSearchButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage)
{
	CTSearchButton *pRet = new CTSearchButton();
	if (pRet && pRet->initCTButton(pStrNormalImage,pStrSelectedImage,pStrDisableImage))
	{
		pRet->autorelease();
		return pRet;
	}
	CC_SAFE_DELETE(pRet);
	return pRet;
}
void CTSearchButton::setEditBoxBinding(CTEditBox *pEditBox)
{
	m_pEditBox = pEditBox;
}
void CTSearchButton::active()
{   
	std::string str;
	str.clear();
	str.append(this->getChar());
	str.append(m_pEditBox->getInputString());
	CCLog("click CTSearchButton!  == %s",str.c_str());
	if (kScriptTypeNone != m_eScriptType)
	{
		//CCScriptEngineManager::sharedManager()->getScriptEngine()->executeCTButtonEvent((CTBase*)this,getType(),str.c_str());
#if     1
		CCScriptEngineManager::sharedManager()->getScriptEngine()->executeCTButtonEvent((CTBase*)this,getType(),getChar());
#else
		CCScriptEngineProtocol* pScriptEngineProtocol = CCScriptEngineManager::sharedManager()->getScriptEngine();
		int ret = 0;
		do 
		{
			int nScriptHandler = this->getScriptTapHandler();
			CC_BREAK_IF(0 == nScriptHandler);

			lua_State *m_state = pScriptEngineProtocol->g
//			cleanStack();
// 			pushInt(getType());
// 			pushString(str.c_str());
            lua_settop(m_state, 0);
			lua_pushinteger(m_state,getType());
			lua_pushstring(m_state,str.c_str());
			ret = pScriptEngineProtocol->executeFunctionByHandler(nScriptHandler, 2);
		} while (0);
		//return ret;
#endif
	}
}