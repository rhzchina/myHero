--卡牌信息
CILayer= {
	layer,  --信息头
}

function CILayer:create(type,id,point_x,point_y,params)
	local this={}
	setmetatable(this,self)
	self.__index = self
	this.params = params or {}
	this.layer = display.newLayer()
	--this.layer:setPosition(ccp(point_x,point_y))

	if type == 1 then
		local header_bg = CCSprite:create("image/UserAvatar/UserAvatarbg.png")
		header_bg:setAnchorPoint(ccp(0,0))
		this.layer:addChild(header_bg)
		local header_box = CCSprite:create("image/UserAvatar/UserAvatarbox.png")
		local header = CCSprite:create("image/myhero/small/"..id..".png")

		header_box:setAnchorPoint(ccp(0,0))
		header:setAnchorPoint(ccp(0,0))

		this.layer:addChild(header)
		this.layer:addChild(header_box)
		this.layer:setContentSize(CCSize:new(header_box:getContentSize().width+20,header_box:getContentSize().height))
	elseif type == 2 then
		local header_bg = CCSprite:create("image/UserAvatar/nouserbg.png")
		header_bg:setAnchorPoint(ccp(0,0))
		this.layer:addChild(header_bg)

		local header_box = CCSprite:create("image/UserAvatar/nouser.png")
		header_box:setAnchorPoint(ccp(0,0))
		this.layer:addChild(header_box)
		this.layer:setContentSize(CCSize:new(header_box:getContentSize().width+20,header_box:getContentSize().height))
	else
		local header_box = CCSprite:create("image/UserAvatar/suo.png")
		header_box:setAnchorPoint(ccp(0,0))
		this.layer:addChild(header_box)
		this.layer:setContentSize(CCSize:new(header_box:getContentSize().width+20,header_box:getContentSize().height))
	end

	this.layer:setTouchEnabled(true)

	function this.layer:onTouch(type, x, y)

		if type == CCTOUCHBEGAN then

		elseif type == CCTOUCHMOVED then

		elseif type == CCTOUCHENDED then
				if this:getRange():containsPoint(ccp(x,y)) then
									if params["callback"] then
										params["callback"]()
									end
					end
		end
		return true
	end

	this.layer:registerScriptTouchHandler(function(type,x,y) return this.layer:onTouch(type,x,y) end,false,-128,false)

	return this
end


function CILayer:getRange()
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

function CILayer:getLayer()
	return self.layer
end
