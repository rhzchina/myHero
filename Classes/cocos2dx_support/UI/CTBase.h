#ifndef __CTBase_h__
#define __CTBase_h__

#include "cocos2d.h"
USING_NS_CC;
class CTBase:public CCNode
{
public:
	CTBase()
		:m_nParamsType(-1)
		,m_pParamsChar(NULL)
		, m_nScriptTapHandler(0)
	{
	}
	~CTBase();
	void setParams(int type,char* pstr);
	int getType();
	const char* getChar();
	virtual void registerScriptTapHandler(int nHandler);
	virtual void unregisterScriptTapHandler(void);
	int getScriptTapHandler() { return m_nScriptTapHandler; };
	int  m_nScriptTapHandler;
private:
	int m_nParamsType;
	char* m_pParamsChar;
};
#endif