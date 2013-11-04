#ifndef GAMELEAD_H 
#define GAMELEAD_H 

#include "cocos2d.h"

using namespace cocos2d;

class GameLead : public CCSprite , public CCTargetedTouchDelegate
{
public:
	GameLead();
	virtual ~GameLead();

	virtual bool init();
	virtual void onEnter();
	virtual void onExit();

	virtual bool ccTouchBegan(CCTouch *touch, CCEvent *event);
	virtual void ccTouchMoved(CCTouch *touch, CCEvent *event);
	virtual void ccTouchEnded(CCTouch *touch, CCEvent *event);

	static GameLead* createSprite();
	void show(float width,float height,CCPoint * point , float opacity , int callback , int callback2);
	CCLayerColor *m_layer; // color layer
	float m_layerWidth; //layer width 
	float m_layerHeight; // layer height 
	CCRenderTexture *m_pTarget; // render texture
	int m_callback;
	int m_callback2;
};
#endif