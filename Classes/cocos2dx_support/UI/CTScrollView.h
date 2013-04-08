#ifndef __CTScrollView_h__
#define __CTScrollView_h__

#include "cocos2d.h"
#include "cocos-ext.h"
USING_NS_CC;
USING_NS_CC_EXT;

class CTScrollView:public CCScrollView
{
public:
	bool initWithViewSize(CCSize size, CCNode* container = NULL);
	void setDelegate(CCScrollViewDelegate* pDelegate);
	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
	virtual void MoveBy(float fDistance);
};
#endif