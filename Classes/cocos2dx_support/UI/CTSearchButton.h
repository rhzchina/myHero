#ifndef __CTSearchButton_h__
#define __CTSearchButton_h__
#include "cocos2d.h"
#include "cocos-ext.h"
#include "CTButton.h"
#include "CTEditBox.h"
//#include "ClickManager.h"
USING_NS_CC;
USING_NS_CC_EXT;

class CTSearchButton:public CTButton
{
public:/*有3种模式的按钮，其中pStrNormalImage为必须参数
	   1：是只有pStrNormalImage，其他参数为NULL,表示该按钮按下的图片和弹起来的图片一样。
	   2:有pStrNormalImage和pStrSelectedImage，其他为NULL,表示按下去的图片和弹起来的图片不一样。
	   3：3种状态都有，如果setCDownTime设置的值大于0,点击弹起后按钮会进入不可用状态，经过对应的时间后自动回到可用状态。
*/
	static CTSearchButton* createCTSearchButton(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage);
public:
	virtual void active();
	void setEditBoxBinding(CTEditBox *pEditBox);
	CTEditBox *m_pEditBox;
};
#endif   