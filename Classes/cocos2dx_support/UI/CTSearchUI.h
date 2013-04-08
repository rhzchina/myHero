#ifndef __CTSearchUI_h__
#define __CTSearchUI_h__
#include "cocos2d.h"
#include "CTSearchButton.h"
#include "CTEditBox.h"
USING_NS_CC;
class CTSearchUI:public CCNode
{
public:
	/*
	*搜索框，pStrNormalImage：按钮图未选中,pStrSelectedImage：按钮选中,pStrDisableImage:按钮不可用,
	placeholder:编辑框默认文本,fontName:字体类型，fontSize：字体大小,type:按钮输入类型（场景id），pParams：响应事件类型
	*/
	static CTSearchUI* createCTSearchUI(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage,
		const char *placeholder, const char *fontName, float fontSize,int type,char *pParams);	
	
	bool initCTSearchUI(const char *pStrNormalImage,const char *pStrSelectedImage,const char *pStrDisableImage,
		const char *placeholder, const char *fontName, float fontSize,int type,char *pParams);
	/*
	*
	*/
	void setCTSearchUIPosition(CCPoint &ptEditBox,CCPoint &ptBtn);//未完成
	void registerScriptTapHandler(int nHandler);
	void unregisterScriptTapHandler(void);
public:
	CTSearchButton* m_pBtn;
	CTEditBox* m_pEditBox;
};
#endif