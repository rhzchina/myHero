MHLayer= {
	CILayer,   --信息头
}

require "GameScript/Scene/common/CardInfo"

local PATH = IMG_SCENE.."navigation/"

function MHLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = CCLayer:create()
	local bg = newSprite(PATH.."navigation_top.png")
	layer:addChild(bg)

	--等级
	local leve  = newSprite(PATH.."level_bg.png")
	leve:setPosition(ccp(22,20))
	layer:addChild(leve)

	local label_leve = newLabel(DATA_User:get("Gold"),  20)--体力值
	label_leve:setPosition(ccp(47,45));
	layer:addChild(label_leve)

	--用户名
	local label_user = newLabel(DATA_User:get("name"), 20)
	label_user:setPosition(ccp(100,63));
	layer:addChild(label_user)

	local Gas  = newSprite(PATH.."gas_bg.png")
	local Silver  = newSprite(PATH.."silver_bg.png")--银两
	local GoldLeaf  = newSprite(PATH.."gold_bg.png")--金叶子
	local PhysicalValue  = newSprite(PATH.."power_bg.png")

	Gas:setPosition(ccp(345,20))
	Silver:setPosition(ccp(230,60))
	GoldLeaf:setPosition(ccp(345,60))
	PhysicalValue:setPosition(ccp(230,20))

	layer:addChild(Gas)
	layer:addChild(Silver)
	layer:addChild(GoldLeaf)
	layer:addChild(PhysicalValue)

	local label_Gas = newLabel(DATA_User:get("energy"), 20)--体力值
	local label_Silver = newLabel(DATA_User:get("Money"), 20)--体银两
	local label_GoldLeaf = newLabel(DATA_User:get("Coin"),  20)--金叶子
	local label_PhysicalValue = newLabel(DATA_User:get("PhysicalValue"), 20)--气

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

