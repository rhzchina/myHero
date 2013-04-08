
#include "CTEditBox.h"
USING_NS_CC;

const static float DELTA = 0.5f;

CTEditBox::CTEditBox()
{
    CCTextFieldTTF();
    
    m_pCursorSprite = NULL;
    m_pCursorAction = NULL;
    
    m_pInputText = NULL;
}

CTEditBox::~CTEditBox()
{
    delete m_pInputText;
}

void CTEditBox::onEnter()
{
    CCTextFieldTTF::onEnter();
    CCDirector::sharedDirector()->getTouchDispatcher()->addTargetedDelegate(this, 0, false);
    this->setDelegate(this);
}

CTEditBox * CTEditBox::createCTEditBox(const char *placeholder, const char *fontName, float fontSize)
{
    CTEditBox *pRet = new CTEditBox();
    
    if(pRet && pRet->initWithString("", fontName, fontSize))
    {
        pRet->autorelease();
		pRet->setColor(ccWHITE);
        if (placeholder)
        {
            pRet->setPlaceHolder(placeholder);
        }
        pRet->initCursorSprite((int)fontSize);
        
        return pRet;
    }
    
    CC_SAFE_DELETE(pRet);
    
    return NULL;
}

void CTEditBox::initCursorSprite(int nHeight)
{
    // 初始化光标
    int column = 4;
	int* pPixelArr = (int*)malloc(nHeight*column*sizeof(int));
    //int pixels[nHeight][column];
    for (int i=0; i<nHeight; ++i) {
        for (int j=0; j<column; ++j) {
             //pixels[i][j] = 0xffffffff;
			*(pPixelArr+i*column+j) = 0x000000ff;
        }
    }

    CCTexture2D *texture = new CCTexture2D();
    texture->initWithData(pPixelArr, kCCTexture2DPixelFormat_RGB888, 1, 1, CCSizeMake(column, nHeight));
    
    m_pCursorSprite = CCSprite::createWithTexture(texture);
    CCSize winSize = getContentSize();
    m_cursorPos = ccp(0, winSize.height / 2);
    m_pCursorSprite->setPosition(m_cursorPos);
    this->addChild(m_pCursorSprite);
    
    m_pCursorAction = CCRepeatForever::create((CCActionInterval *) CCSequence::create(CCFadeOut::create(0.25f), CCFadeIn::create(0.25f), NULL));
    
    m_pCursorSprite->runAction(m_pCursorAction);
    
    m_pInputText = new std::string();
	//CC_SAFE_DELETE(texture);
	CC_SAFE_FREE(pPixelArr);

	m_nLimitedLen = 10;
}
void CTEditBox::setLimitedLen(int nLimitedLen)
{
	m_nLimitedLen = nLimitedLen>=0?nLimitedLen:0;
}
bool CTEditBox::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{    
    m_beginPos = pTouch->getLocationInView();
    m_beginPos = CCDirector::sharedDirector()->convertToGL(m_beginPos);
    
    return true;
}

CCRect CTEditBox::getRect()
{
    CCSize size = getContentSize();
    
    return  CCRectMake(-size.width / 2, -size.height / 2, size.width, size.height);
}

bool CTEditBox::isInTextField(cocos2d::CCTouch *pTouch)
{
    return getRect().containsPoint(convertTouchToNodeSpaceAR(pTouch));
}

void CTEditBox::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    CCPoint endPos = pTouch->getLocationInView();
    endPos = CCDirector::sharedDirector()->convertToGL(endPos);
    
    // 判断是否为点击事件
    if (::abs(endPos.x - m_beginPos.x) > DELTA || 
        ::abs(endPos.y - m_beginPos.y)) 
    {
        // 不是点击事件
       // m_beginPos.x = m_beginPos.y = -1;
        
        //return;
    }
    
    CCLOG("width: %f, height: %f.", getContentSize().width, getContentSize().height);
    
    // 判断是打开输入法还是关闭输入法
    isInTextField(pTouch) ? openIME() : closeIME();
}
const char* CTEditBox::getInputString()
{
	return m_pInputText->c_str();
}
bool CTEditBox::onTextFieldAttachWithIME(cocos2d::CCTextFieldTTF *pSender)
{
    if (m_pInputText->empty()) {
        return false;
    }
    
    m_pCursorSprite->setPositionX(getContentSize().width);
    
    return false;
}

bool CTEditBox::onTextFieldInsertText(cocos2d::CCTextFieldTTF *pSender, const char *text, int nLen)
{
    CCLOG("Width: %f", pSender->getContentSize().width);
    CCLOG("Text: %s", text);
    CCLOG("Length: %d", nLen);
	if ('\n' == *text)
	{
		return true;
	}

	// if the textfield's char count more than m_nCharLimit, doesn't insert text anymore.
	if (pSender->getCharCount() >= m_nLimitedLen)
	{
		return true;
	}

    m_pInputText->append(text);
    setString(m_pInputText->c_str());
    
    m_pCursorSprite->setPositionX(getContentSize().width);
    
    return true;
}

bool CTEditBox::onTextFieldDeleteBackward(cocos2d::CCTextFieldTTF *pSender, const char *delText, int nLen)
{
    m_pInputText->resize(m_pInputText->size() - nLen);
    setString(m_pInputText->c_str());
    
    m_pCursorSprite->setPositionX(getContentSize().width);
    
    if (m_pInputText->empty()) {
        m_pCursorSprite->setPositionX(0);
    }
    
    return false;
}

bool CTEditBox::onTextFieldDetachWithIME(cocos2d::CCTextFieldTTF *pSender)
{
    return false;
}

void CTEditBox::openIME()
{
    m_pCursorSprite->setVisible(true);
    this->attachWithIME();
}

void CTEditBox::closeIME()
{
    m_pCursorSprite->setVisible(false);
    this->detachWithIME();
}

void CTEditBox::onExit()
{
    CCTextFieldTTF::onExit();
    CCDirector::sharedDirector()->getTouchDispatcher()->removeDelegate(this);
}