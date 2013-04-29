MHLayer= {
	CILayer,   --信息头
}

require "GameScript/Scene/common/CardInfo"

function MHLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = CCLayer:create()
	local bg = CCSprite:create("image/scene/home/MHbg.png")
	bg:setAnchorPoint(ccp(0,0))
	layer:addChild(bg)

	--等级
	local leve  = CCSprite:create("image/scene/home/Level.png")
	leve:setAnchorPoint(ccp(0,0))
	leve:setPosition(ccp(22,20))
	layer:addChild(leve)

	local label_leve = CCLabelTTF:create(DATA_User:get("Gold"), "TimesNewRomanPS-ItalicMT", 20)--体力值
	label_leve:setAnchorPoint(ccp(0,0))
	label_leve:setPosition(ccp(47,45));
	layer:addChild(label_leve)

	--用户名
	local label_user = CCLabelTTF:create(DATA_User:get("name"), "TimesNewRomanPS-ItalicMT", 20)
	label_user:setAnchorPoint(ccp(0,0))
	label_user:setPosition(ccp(100,63));
	layer:addChild(label_user)

	local Gas  = CCSprite:create("image/scene/home/Gas_bg.png")--体力值
	local Silver  = CCSprite:create("image/scene/home/Silver_bg.png")--银两
	local GoldLeaf  = CCSprite:create("image/scene/home/GoldLeaf.png")--金叶子
	local PhysicalValue  = CCSprite:create("image/scene/home/PhysicalValue.png")--气

	Gas:setAnchorPoint(ccp(0,0))
	Silver:setAnchorPoint(ccp(0,0))
	GoldLeaf:setAnchorPoint(ccp(0,0))
	PhysicalValue:setAnchorPoint(ccp(0,0))

	Gas:setPosition(ccp(345,20))
	Silver:setPosition(ccp(230,60))
	GoldLeaf:setPosition(ccp(345,60))
	PhysicalValue:setPosition(ccp(230,20))

	layer:addChild(Gas)
	layer:addChild(Silver)
	layer:addChild(GoldLeaf)
	layer:addChild(PhysicalValue)

	local label_Gas = CCLabelTTF:create(DATA_User:get("energy"), "TimesNewRomanPS-ItalicMT", 20)--体力值
	local label_Silver = CCLabelTTF:create(DATA_User:get("Money"), "TimesNewRomanPS-ItalicMT", 20)--体银两
	local label_GoldLeaf = CCLabelTTF:create(DATA_User:get("Coin"), "TimesNewRomanPS-ItalicMT", 20)--金叶子
	local label_PhysicalValue = CCLabelTTF:create(DATA_User:get("PhysicalValue"), "TimesNewRomanPS-ItalicMT", 20)--气

	label_Gas:setAnchorPoint(ccp(0,0))
	label_Silver:setAnchorPoint(ccp(0,0))
	label_GoldLeaf :setAnchorPoint(ccp(0,0))
	label_PhysicalValue :setAnchorPoint(ccp(0,0))


	label_Gas:setPosition(ccp(395,27))
	label_Silver:setPosition(ccp(280,67))
	label_GoldLeaf:setPosition(ccp(395,67))
	label_PhysicalValue:setPosition(ccp(280,27))

	layer:addChild(label_Gas)
	layer:addChild(label_Silver)
	layer:addChild(label_GoldLeaf)
	layer:addChild(label_PhysicalValue)

	--[[
	--添加人物头像信息
	--

	local Card = CILayer:create(1001,10,14)
	this.CILayer = CCLayer:create()
	this.CILayer:addChild(Card)
	layer:addChild(this.CILayer)
	]]
	layer:setPosition(ccp(x,y))
	return layer

end

