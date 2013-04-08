#ifndef _ANIMATE_PACKER_H_
#define _ANIMATE_PACKER_H_

#include <string>
#include <map>
#include <vector>
#include <set>
#include "cocos2d.h"
//#include "Singleton.h"
USING_NS_CC;

struct Animate{
	std::string name;
	float delay;
	bool flipX;
	bool flipY;
	std::vector<std::string> spriteFrames;
};

class AnimatePacker
{
public:
	static AnimatePacker *getInstance();
	void loadAnimations(const char *path);
	void freeAnimations(const char *path);
	//使用此功能，以获得原始的动画(without FilpX and FlipY).
	CCAnimate* getAnimate(const char *name);
	//这的功能支持FlipX和FlipY.
	CCSequence* getSequence(const char *name);
private:
	//The two functions is came from Timothy Zhang. Thank him for his share.

	CCSequence *createSequence(CCArray *actions);
	CCSequence *createSequence(CCFiniteTimeAction *pAction1, CCFiniteTimeAction *pAction2, ...);

	//From animate name to CCAnimates
	std::map<std::string,Animate> nameToAnimateMap;
	//From xml path to plist names
	std::map<std::string,std::vector<std::string> > pathToPlistsMap;
	//From xml path to animate names
	std::map<std::string,std::set<std::string> > pathToNameMap;
};

#endif//_ANIMATE_PACKER_H_

