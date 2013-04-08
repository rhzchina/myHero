#include "CTScrollView.h"
USING_NS_CC;
USING_NS_CC_EXT;


bool CTScrollView::initWithViewSize(CCSize size, CCNode* container)
{
	return CCScrollView::initWithViewSize(size,container);
}
void CTScrollView::setDelegate(CCScrollViewDelegate* pDelegate)
{
	return CCScrollView::setDelegate(pDelegate);
}
bool CTScrollView::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
	return CCScrollView::ccTouchBegan(pTouch,pEvent);
}
void CTScrollView::ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent)
{
	return CCScrollView::ccTouchMoved(pTouch,pEvent);
}
void CTScrollView::ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent)
{
	return CCScrollView::ccTouchEnded(pTouch,pEvent);
}

void CTScrollView::MoveBy(float fDistance)
{
	CCPoint moveDistance, newPoint, maxInset, minInset;
	float newX, newY;
	CCPoint ptTest,offset;
	switch (m_eDirection)
	{
	case kCCScrollViewDirectionVertical:
		moveDistance = ccp(0.0f, fDistance);
		break;
	case kCCScrollViewDirectionHorizontal:
		moveDistance = ccp(fDistance, 0.0f);
		break;
	default:
		break;
	}
	m_pContainer->setPosition(ccpAdd(m_pContainer->getPosition(), moveDistance));

	maxInset = this->maxContainerOffset();
	minInset = this->minContainerOffset();

	newX     = MIN(m_pContainer->getPosition().x, maxInset.x);
	newX     = MAX(newX, minInset.x);
	newY     = MIN(m_pContainer->getPosition().y, maxInset.y);
	newY     = MAX(newY, minInset.y);

	m_tScrollDistance     = ccpSub(moveDistance, ccp(newX - m_pContainer->getPosition().x, newY - m_pContainer->getPosition().y));
#if 1
	this->setContentOffset(ccp(newX, newY));
#endif
}