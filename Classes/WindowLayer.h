#ifndef WINDOWLAYER_H
#define WINDOWLAYER_H
#include "cocos2d.h"
USING_NS_CC;
class  WindowLayer :	public CCLayerColor 
{
public:
	void visit();
	static WindowLayer* createWindow();
private:
	float scaleX;
	float scaleY;
};
#endif
