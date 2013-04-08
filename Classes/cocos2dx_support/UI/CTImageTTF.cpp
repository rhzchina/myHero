#include "CTImageTTF.h"
USING_NS_CC;

CTImageTTF* CTImageTTF::createImageTTF(
	const char* bgImage,
	const char* strValue,
	float fStartX,const char *fontName, float fontSize
	)
{
	CTImageTTF* pRet = new CTImageTTF();
	if (pRet && pRet->initImageTTF(bgImage,strValue,fStartX,fontName,fontSize))
	{
		pRet->autorelease();

	}
	else
	{
		delete pRet;
		pRet = NULL;
	}
	return pRet;
}

bool CTImageTTF::initImageTTF(
	const char* bgImage,
	const char* strValue,
	float fStartX,const char *fontName, float fontSize
	)
{
	bool bRet = false;
	do 
	{  
		CCSize sizeTemp;
		CCPoint ptTemp;
		m_sprBg = CCSprite::create(bgImage);
		sizeTemp = m_sprBg->getContentSize();
		ptTemp = m_sprBg->getPosition();
		this->addChild(m_sprBg);

		m_lbStrValue = CCLabelTTF::create(strValue,fontName,fontSize);
		//m_lbStrValue->setAnchorPoint(ccp(0,0));
		m_lbStrValue->setPosition(ccp(-(sizeTemp.width/2-fStartX),0));
		this->addChild(m_lbStrValue);

		this->setContentSize(sizeTemp);
		bRet = true;
	} while (0);
	return bRet;
}
void CTImageTTF::setImageTTFString(const char *strValue)
{
	m_lbStrValue->setString(strValue);
}
void CTImageTTF::setImageTTFColor(const ccColor3B& color)
{
	m_lbStrValue->setColor(color);
}