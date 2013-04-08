#include "CTSearchUI.h"
USING_NS_CC;

CTSearchUI* CTSearchUI::createCTSearchUI(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage,
	const char *placeholder, const char *fontName, float fontSize,int type,char *pParams)
{
	CTSearchUI* pRet = new CTSearchUI();
	if(pRet && pRet->initCTSearchUI(pStrNormalImage,pStrSelectedImage,pStrDisableImage,
		placeholder,fontName,fontSize,type,pParams))
	{

	}
	else
	{
		CC_SAFE_DELETE(pRet);
	}
	return pRet;
}



bool CTSearchUI::initCTSearchUI(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage,
	const char *placeholder, const char *fontName, float fontSize,int type,char *pParams)
{
	bool bRet = 0;
	do 
	{  
		CCSize sizeTemp;
		CCPoint ptTemp;
		m_pBtn = CTSearchButton::createCTSearchButton(pStrNormalImage,pStrSelectedImage,pStrDisableImage);
		sizeTemp = m_pBtn->getContentSize();
		m_pBtn->setPosition(ccp(sizeTemp.width/2,0));
		m_pBtn->setParams(type,pParams);
		this->addChild(m_pBtn);

		m_pEditBox = CTEditBox::createCTEditBox(placeholder,fontName,fontSize);
		sizeTemp = m_pEditBox->getContentSize();
		m_pEditBox->setPosition(ccp(-sizeTemp.width/2,0));
		this->addChild(m_pEditBox);

		m_pBtn->setEditBoxBinding(m_pEditBox);
		bRet = true;
	} while (0);
	return bRet;
}
void CTSearchUI::setCTSearchUIPosition(CCPoint &ptEditBox,CCPoint &ptBtn)
{  
}

void CTSearchUI::registerScriptTapHandler(int nHandler)
{
	m_pBtn->registerScriptTapHandler(nHandler);
}
void CTSearchUI::unregisterScriptTapHandler(void)
{
	m_pBtn->unregisterScriptTapHandler();
}