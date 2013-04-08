function CreateBGLayer()
	local menuLayer = CCLayer:create()
	local winSize = CCDirector:sharedDirector():getWinSize()
	local bg = CCSprite:create("image/home_page/bg.jpg")
	---设置这个精灵实例的位置
	--bg:setAnchorPoint(0,0)
    bg:setPosition(winSize.width / 2, winSize.height / 2)
	----将精灵放入新创建的Layer中
    menuLayer:addChild(bg)
    return menuLayer
end
