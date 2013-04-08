#ifndef __CTStateBar_h__
#define __CTStateBar_h__
#include "cocos2d.h"
USING_NS_CC;

class CTStateBar:public CCNode
{
public:
	virtual void visit(void);
	//背景图片bgImage为必须参数，该图片确定该控件的ContentSize，fIconStartX是icon左边缘相对该控件左边缘距离，fValueStartX是数值中心相对该控件左边缘距离。
	static CTStateBar* createCTStateBar(const char *bgImage,const char *foreImage,const char *iconImage,float fIconStartX,float fValueStartX);
	bool initCTStateBar(const char *bgImage,const char *foreImage,const char *iconImage,float fIconStartX,float fValueStartX);
	void setCTStateBarValue(float fCur,float fMax);//进度对比度，fcur是当前数值，fmax是最大数值
	void setCTStateBarPosition(CCPoint &pt);//该坐标自身左上角是相对于屏幕左上角的坐标，

private:
	CCLabelTTF *m_lbStrValue;
	CCSprite *m_sprFore;
	CCSprite *m_sprBg;
	CCSprite *m_sprIcon;
	float m_fCur,m_fMax;
	CCSize m_selfSize;
private:
	CCString *createCStrValue();
};


#endif