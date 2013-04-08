#ifndef __CTImageTTF_h__
#define __CTImageTTF_h__
#include "cocos2d.h"
USING_NS_CC;

enum
{
	CTIMGTTF_Z_BG,
	CTIMGTTF_Z_FONT,
};

/*
*背景图的静态文本
*
*/

class CTImageTTF:public CCNode
{
public:
	CCLabelTTF *m_lbStrValue;
	CCSprite *m_sprBg;
public:
	/*
	*bgImage:背景图
	*strValue：字符串
	*fStartX：字符串中心点相对x坐标轴的距离
	*fontName:字体类型
	*fontSize:字体大小
	*/
	static CTImageTTF* createImageTTF(
		const char* bgImage,
		const char* strValue,
		float fStartX,const char *fontName, float fontSize
		);

	bool initImageTTF(
		const char* bgImage,
		const char* strValue,
		float fStartX,const char *fontName, float fontSize
		);
	/*
	*strValue:重置字符串
	**/
	void setImageTTFString(const char *strValue);
	/*
	*color:字体颜色
	*/
	void setImageTTFColor(const ccColor3B& color);
};
#endif