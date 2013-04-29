
---[[选择武将上阵]]

--英雄上阵
HLPLayer= {
	layer,  --信息头
	intro_selct,
	is_true,
	is_select,
	id
}
local card = require"GameScript/Scene/common/CardInfo"
function HLPLayer:new(data,point_x,point_y,params)
	local this={}
	setmetatable(this,self)
	self.__index = self
	this.params = params or {}
	this.layer = CCLayer:create()
	this.intro_selct = nil
	this.is_true = false
	this.is_select = false
	this.id = data["card_id"]
	local intro_bg = CCSprite:create("image/scene/herolup/intro_bg.png")
	setAnchPos(intro_bg,10,0)
	this.layer:addChild(intro_bg)

	this.layer:setContentSize(intro_bg:getContentSize())

	local header_bg = CCSprite:create("image/UserAvatar/UserAvatarbg.png")
	setAnchPos(header_bg,22,17)
	this.layer:addChild(header_bg)
	local header_box = CCSprite:create("image/UserAvatar/UserAvatarbox.png")
	local header = CCSprite:create("image/myhero/small/"..data["card_id"]..".png")

	setAnchPos(header_box,22,17)
	setAnchPos(header,22,17)

	this.layer:addChild(header)
	this.layer:addChild(header_box)

	local text_name = CCLabelTTF:create(data["name"], "Arial" , 25)
	setAnchPos(text_name,120,70)
	this.layer:addChild(text_name)

	local text_lev = CCLabelTTF:create("Lv "..data["lev"], "Arial" , 25)
	setAnchPos(text_lev,240,70)
	this.layer:addChild(text_lev)

	local text_other = CCLabelTTF:create("血："..data["hp"].." 防："..data["defe"].." 攻："..data["att"], "Arial" , 25)
	setAnchPos(text_other,120,20)
	this.layer:addChild(text_other)

	local intro_box= CCSprite:create("image/scene/herolup/box.png")
	setAnchPos(intro_box,420,60)
	this.layer:addChild(intro_box)

	this.intro_selct = CCSprite:create("image/scene/herolup/true.png")
	setAnchPos(this.intro_selct,420,60)
	this.intro_selct:setVisible(false)
	this.layer:addChild(this.intro_selct)



	this.layer:setTouchEnabled(true)
	function this.layer:onTouch(type, x, y)

		if this.params["parent"] and not this.params["parent"]:isLegalTouch(x,y) then
			return false
		end

		if type == CCTOUCHBEGAN then

		elseif type == CCTOUCHMOVED then

		elseif type == CCTOUCHENDED then
					--放开后执行回调
					if this:getRange():containsPoint(ccp(x,y)) then
									if params["callback"] then
										params["callback"](this)
									end
					end
		end
		return true
	end
	this.layer:registerScriptTouchHandler(function(type,x,y) return this.layer:onTouch(type,x,y) end,false,-50,false)
return this
end

function HLPLayer:getLayer()
	return self.layer
end

function HLPLayer:set_true(is_trues)
	self.is_true = is_trues
	self.intro_selct:setVisible(is_trues)
end

function HLPLayer:get_true()
	return self.is_true
end

function HLPLayer:set_select(is_select)
	self.is_select = is_select
end

function HLPLayer:get_select()
	return self.is_select
end

function HLPLayer:set_id(uid)

end

function HLPLayer:get_id()
	return self.id
end

function HLPLayer:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	x = x + parent:getPositionX()
	y = y + parent:getPositionY()
	while parent:getParent() do
		parent = parent:getParent()
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()
	end
	return CCRectMake(x,y,self.layer:getContentSize().width,self.layer:getContentSize().height)
end

return HLPLayer
