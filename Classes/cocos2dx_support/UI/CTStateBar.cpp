#include "CTStateBar.h"
USING_NS_CC;

void CTStateBar::visit(void)
{
#if 1
	float x,y,w,h,s;
	x = this->getPosition().x;
	y = this->getPosition().y;
	w = m_selfSize.width;
	h = m_selfSize.height;
	s = this->getScale();
	glEnable(GL_SCISSOR_TEST);
	CCEGLView::sharedOpenGLView()->setScissorInPoints((x-m_selfSize.width/2)*s, (y-m_selfSize.height/2)*s, m_selfSize.width*s, m_selfSize.height*s);
	CCNode::visit();
	glDisable(GL_SCISSOR_TEST);
#else
	CCNode::visit();
#endif
}

CTStateBar* CTStateBar::createCTStateBar(const char*bgImage,const char*foreImage,const char *iconImage,float fIconStartX,float fValueStartX)
{
	CTStateBar* pRet = new CTStateBar();
	if (pRet && pRet->initCTStateBar(bgImage,foreImage,iconImage,fIconStartX,fValueStartX))
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
bool CTStateBar::initCTStateBar(const char*bgImage,const char*foreImage,const char *iconImage,float fIconStartX,float fValueStartX)
{
	bool bRet = false;
	do 
	{
		CCSize sizeTemp;
		CCPoint ptTemp;

		m_sprBg = CCSprite::create(bgImage);
		m_selfSize = m_sprBg->getContentSize();
		this->addChild(m_sprBg);


		m_sprFore = CCSprite::create(foreImage);
		m_selfSize = m_sprFore->getContentSize();
		this->addChild(m_sprFore);

		this->setContentSize(m_selfSize);

		if (iconImage)
		{
			m_sprIcon = CCSprite::create(iconImage);
			sizeTemp = m_sprIcon->getContentSize();
			m_sprIcon->setPosition(ccp(-(0.5*m_selfSize.width-fIconStartX-sizeTemp.width/2),0));
			this->addChild(m_sprIcon);
		}


		m_fCur = 0;m_fMax = 0;
		m_lbStrValue = CCLabelTTF::create(createCStrValue()->getCString(),"Arial",20);
		m_lbStrValue->setPosition(ccp(-(0.5*m_selfSize.width-fValueStartX),0));
		this->addChild(m_lbStrValue);

		

		bRet = true;
	} while (0);
	return bRet;
}
CCString* CTStateBar::createCStrValue()
{
	return CCString::createWithFormat("%d/%d",(int)m_fCur,(int)m_fMax);
}

void CTStateBar::setCTStateBarValue(float fCur,float fMax)
{
	m_fCur = fCur;
	m_fMax = fMax;
	m_lbStrValue->setString(this->createCStrValue()->getCString());
	int fDrawCur,fDrawMax;
	fDrawCur = m_fCur;
	fDrawMax = m_fMax;
	if (fDrawMax <= 0)
	{
		fDrawMax = 1;
		fDrawCur = 0;
	}
	m_sprFore->setPosition(ccp(-m_selfSize.width*(1-m_fCur/m_fMax),0));
}

void CTStateBar::setCTStateBarPosition(CCPoint &pt)
{
	CCPoint ptFinal = pt;
	ptFinal.x+=m_selfSize.width/2;
	ptFinal.y+=m_selfSize.height/2;
	ptFinal = CCDirector::sharedDirector()->convertToGL(ptFinal);
	this->setPosition(ptFinal);
}