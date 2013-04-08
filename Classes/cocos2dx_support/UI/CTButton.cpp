#include "CTButton.h"
USING_NS_CC;
USING_NS_CC_EXT;
const static float DELTA = 0.5f;

CTButton::~CTButton()
{
	//CC_SAFE_DELETE(m_pStrParams);
}
void CTButton::onExit()
{//按键弹起状态
	CCNode::onExit();
	CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
}
void CTButton::onEnter()
{//
	CCNode::onEnter();
	CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
	//this->setDelegate(this);
}

//创建button，
CTButton* CTButton::createCTButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage)
{
	CTButton *pRet = new CTButton();
	if (pRet && pRet->initCTButton(pStrNormalImage,pStrSelectedImage,pStrDisableImage))
	{
		pRet->autorelease();
		return pRet;
	}
	CC_SAFE_DELETE(pRet);
	return pRet;
}
/*******
*功能:创建button
*参数：pStrNormalImage 
*******/
bool CTButton::initCTButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage)
{
	bool bRet = false;
	do 
	{
		CCSprite *pSpr;
		CCSize sizeTemp;
		sizeTemp = CCSizeMake(0,0);
		m_selfSize = CCSizeMake(0,0);
		if (pStrNormalImage)
		{
			m_bNorImgExisted = true;
			pSpr = CCSprite::create(pStrNormalImage);
			this->addChild(pSpr,0,kTagCTButtonNormalImage);
			sizeTemp = pSpr->getContentSize();
			this->setContentSize(sizeTemp);
			m_selfSize = pSpr->getContentSize();
		}

		if (pStrSelectedImage)
		{
			m_bSelImgExisted = true;
			pSpr = CCSprite::create(pStrSelectedImage);
			this->addChild(pSpr,0,kTagCTButtonSelectedImage);
			pSpr->setVisible(false);

		}

		if (pStrDisableImage)
		{
			m_bDisImgExisted = true;
			pSpr = CCSprite::create(pStrDisableImage);
			this->addChild(pSpr,0,kTagCTButtonDisableImage);
			pSpr->setVisible(false);
		}

		m_nStateCurrent = kTagCTButtonStateNormal;
		m_beginPos = ccp(-1,-1);
		m_bIsEnabled = true;
		bRet = true;
	} while (0);
	return bRet;
}


//触摸点击
bool CTButton::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	if (!this->isVisible() || !this->isEnabled())
	{
		return false;
	}
	m_beginPos = pTouch->getLocationInView();
	m_beginPos = CCDirector::sharedDirector()->convertToGL(m_beginPos);
	if (isInSelf(pTouch))
	{
		if (m_nStateCurrent != kTagCTButtonStateSelected)
		{
			m_nStateCurrent = kTagCTButtonStateSelected;
			CCObject *pObject;
			CCARRAY_FOREACH(this->getChildren(),pObject)
			{ 
				CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
				int nCurTag = pSpr->getTag();
				if (m_bSelImgExisted)
				{
					if(nCurTag == kTagCTButtonSelectedImage)
					{
						pSpr->setVisible(true);
					}
					else
					{
						pSpr->setVisible(false);
					}
				}
			}
		}
		return true;
	}
	return false;
}
//触摸拖动
void CTButton::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
	if (!this->isVisible() || !this->isEnabled())
	{
		return;
	}
	if (isInSelf(pTouch))
	{
		if (m_nStateCurrent != kTagCTButtonStateSelected)
		{
			m_nStateCurrent = kTagCTButtonStateSelected;
			CCObject *pObject;
			CCARRAY_FOREACH(this->getChildren(),pObject)
			{ 
				CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
				int nCurTag = pSpr->getTag();
				if (m_bSelImgExisted)
				{
					if(nCurTag == kTagCTButtonSelectedImage)
					{
						pSpr->setVisible(true);
					}
					else
					{
						pSpr->setVisible(false);
					}
				}
			}
		}
	}
	else
	{
		if (m_nStateCurrent != kTagCTButtonStateNormal)
		{
			m_nStateCurrent = kTagCTButtonStateNormal;
			CCObject *pObject;
			CCARRAY_FOREACH(this->getChildren(),pObject)
			{ 
				CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
				int nCurTag = pSpr->getTag();
				if(nCurTag == kTagCTButtonNormalImage)
				{
					pSpr->setVisible(true);
				}
				else if(nCurTag == kTagCTButtonSelectedImage || nCurTag  == kTagCTButtonDisableImage)
				{
					pSpr->setVisible(false);
				}
			}
		}
	}

	
}

//触摸弹起
void CTButton::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	if (!this->isVisible() || !this->isEnabled())
	{
		return;
	}
	if (m_nStateCurrent != kTagCTButtonStateNormal)
	{
		m_nStateCurrent = kTagCTButtonStateNormal;
		CCObject *pObject;
		CCARRAY_FOREACH(this->getChildren(),pObject)
		{ 
			CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
			int nCurTag = pSpr->getTag();
			if(nCurTag == kTagCTButtonNormalImage)
			{
				pSpr->setVisible(true);
			}
			else if(nCurTag == kTagCTButtonSelectedImage || nCurTag  == kTagCTButtonDisableImage)
			{
				pSpr->setVisible(false);
			}
		}
	}
	CCPoint endPos = pTouch->getLocationInView();
	endPos = CCDirector::sharedDirector()->convertToGL(endPos);


	if (isInSelf(pTouch) && isInSelf(m_beginPos))
	{  
		if (m_bDisImgExisted && m_nCDTime > 0)
		{
			this->setEnabled(false);
			this->unscheduleAllSelectors();
			this->scheduleOnce(schedule_selector(CTButton::CDTimeCallBack),(float)m_nCDTime);
		}
#if 0
		ClickManager::sharedClickManager()->click_Type(m_type,m_pStrParams);
#else
		active();
#endif
	}
}

//设置是否可用
void CTButton::setEnabled(bool value)
{
	m_bIsEnabled = value;
	if (m_nStateCurrent != kTagCTButtonStateDisable && m_bIsEnabled == false)
	{
		m_nStateCurrent = kTagCTButtonStateDisable;
		CCObject *pObject;
		CCARRAY_FOREACH(this->getChildren(),pObject)
		{ 
			CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
			int nCurTag = pSpr->getTag();
			if (m_bDisImgExisted)
			{
				if(nCurTag == kTagCTButtonDisableImage)
				{
					pSpr->setVisible(true);
				}
				else
				{
					pSpr->setVisible(false);
				}
			}
		}
	}
	else if (m_nStateCurrent != kTagCTButtonStateNormal && m_bIsEnabled == true)
	{
		m_nStateCurrent = kTagCTButtonStateNormal;
		CCObject *pObject;
		CCARRAY_FOREACH(this->getChildren(),pObject)
		{ 
			CCSprite *pSpr = dynamic_cast<CCSprite*>(pObject);
			int nCurTag = pSpr->getTag();
			if (m_bDisImgExisted)
			{
				if(nCurTag == kTagCTButtonStateNormal)
				{
					pSpr->setVisible(true);
				}
				else
				{
					pSpr->setVisible(false);
				}
			}
		}
	}

}
bool CTButton::isEnabled()
{
	return m_bIsEnabled;
}
void CTButton::ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent)
{

}

//获得按钮的坐标
CCRect CTButton::getRect()
{
	CCSize size = getContentSize();

	return  CCRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
}

bool CTButton::isInSelf(cocos2d::CCTouch *pTouch)
{
	return getRect().containsPoint(convertTouchToNodeSpaceAR(pTouch));
}

bool CTButton::isInSelf(CCPoint &pt)
{
	return getRect().containsPoint(convertToNodeSpaceAR(pt));
}


void CTButton::setCDownTime(int nTime)
{
	m_nCDTime = nTime;
}

void CTButton::CDTimeCallBack(float dt)
{
	this->setEnabled(true);
}

void CTButton::setCTButtonPosition(CCPoint &pt)
{
	CCPoint ptFinal = pt;
	ptFinal.x+=m_selfSize.width/2;
	ptFinal.y+=m_selfSize.height/2;
	ptFinal = CCDirector::sharedDirector()->convertToGL(ptFinal);
	this->setPosition(ptFinal);
}

void CTButton::active()
{
	//if (m_bIsEnabled)
	{
// 		if (m_pListener && m_pfnSelector)
// 		{
// 			(m_pListener->*m_pfnSelector)(this);
// 		}

		if (kScriptTypeNone != m_eScriptType)
		{
#if  1
			CCScriptEngineManager::sharedManager()->getScriptEngine()->executeCTButtonEvent((CTBase*)this,getType(),getChar());
#else
			CCScriptEngineProtocol* pScriptEngineProtocol = CCScriptEngineManager::sharedManager()->getScriptEngine();
			int ret = 0;
			do 
			{
				int nScriptHandler = this->getScriptTapHandler();
				CC_BREAK_IF(0 == nScriptHandler);

				cleanStack();
				pushInt(getType());
				pushString(getChar());
				ret = pScriptEngineProtocol->executeFunctionByHandler(nScriptHandler, 2);
			} while (0);
			//return ret;
#endif
		}
	}
}

