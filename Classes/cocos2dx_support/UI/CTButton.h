#ifndef __CTButton_h__
#define __CTButton_h__
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CTBase.h"
//#include "ClickManager.h"
USING_NS_CC;
USING_NS_CC_EXT;
class CTBase;
enum
{
	kTagCTButtonNormalImage = 0,
	kTagCTButtonSelectedImage,
	kTagCTButtonDisableImage,
};
enum
{
	kTagCTButtonStateNormal= 0,
	kTagCTButtonStateSelected,
	kTagCTButtonStateDisable,
};
class CTButton:public CTBase, public CCTouchDelegate
{
public:/*有3种模式的按钮，其中pStrNormalImage为必须参数
	   1：是只有pStrNormalImage，其他参数为NULL,表示该按钮按下的图片和弹起来的图片一样。
	   2:有pStrNormalImage和pStrSelectedImage，其他为NULL,表示按下去的图片和弹起来的图片不一样。
	   3：3种状态都有，如果setCDownTime设置的值大于0,点击弹起后按钮会进入不可用状态，经过对应的时间后自动回到可用状态。
*/
	static CTButton* createCTButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage);
	~CTButton();
	void setCDownTime(int nTime);
	void setCTButtonPosition(CCPoint &pt);//该坐标自身左上角是相对于屏幕左上角的坐标，
	CTButton()
		: m_bIsEnabled(true)
		,m_bNorImgExisted(false)
		,m_bSelImgExisted(false)
		,m_bDisImgExisted(false)
		,m_nCDTime(0)
	{}
public:
	virtual bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent);
	virtual void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent);

	virtual void active();
	bool isInSelf(CCTouch *pTouch);
	bool isInSelf(CCPoint &pt);
	CCRect getRect();
	virtual void setEnabled(bool value);
	bool isEnabled();
	void CDTimeCallBack(float dt);
private:
	bool m_bIsEnabled;
	bool m_bNorImgExisted;
	bool m_bSelImgExisted;
	bool m_bDisImgExisted;
	int m_nCDTime;
	CCSize  m_selfSize;
	CCPoint m_beginPos;
	CCPoint m_cursorPos;
public:
	bool initCTButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage);
	void onEnter();
	void onExit();
	int m_nStateCurrent;
};
#endif   