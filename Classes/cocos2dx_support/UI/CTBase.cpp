#include "CTBase.h"
USING_NS_CC;
CTBase::~CTBase()
{
	CC_SAFE_DELETE(m_pParamsChar);
	unregisterScriptTapHandler();
}
int CTBase::getType()
{
	return m_nParamsType;
}
const char* CTBase::getChar()
{
	return (const char*)m_pParamsChar;
}
void CTBase::setParams(int type,char* pstr)
{
	m_nParamsType = type;
	if (!m_pParamsChar)
	{   
		int len = strlen(pstr);
		m_pParamsChar = new char[len+1];
		strcpy(m_pParamsChar,pstr);
	}
	else
	{
		delete m_pParamsChar;
		m_pParamsChar = NULL;
		int len = strlen(pstr);
		m_pParamsChar = new char[len+1];
		strcpy(m_pParamsChar,pstr);
	}
}
void CTBase::registerScriptTapHandler(int nHandler)
{
	unregisterScriptTapHandler();
	m_nScriptTapHandler = nHandler;
	LUALOG("[LUA] Add CTBase script handler: %d", m_nScriptTapHandler);
}

void CTBase::unregisterScriptTapHandler(void)
{
	if (m_nScriptTapHandler)
	{
		CCScriptEngineManager::sharedManager()->getScriptEngine()->removeScriptHandler(m_nScriptTapHandler);
		LUALOG("[LUA] Remove CTBase script handler: %d", m_nScriptTapHandler);
		m_nScriptTapHandler = 0;
	}
}