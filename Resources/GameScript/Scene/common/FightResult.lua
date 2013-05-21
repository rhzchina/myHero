local FightResult = {
	layer,
	contentLayer
}

function FightResult:new(result)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.contentLayer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."result_bg.png")
	setAnchPos(bg, 245, 420, 0.5, 0.5)
	this.contentLayer:addChild(bg)
	
	if result == 0 then
		bg = newSprite(IMG_COMMON.."win.png")
	else
		bg = newSprite(IMG_COMMON.."lose.png")
	end
	setAnchPos(bg, 245, 580, 0.5)
	this.contentLayer:addChild(bg)
	
	this.contentLayer:setScale(0.1)
	this.contentLayer:runAction(CCEaseBounceInOut:create(CCScaleTo:create(0.4,1)))
	
	this.contentLayer:setTouchEnabled(true)
	this.contentLayer:registerScriptTouchHandler(function(type, x, y)
		if type == CCTOUCHBEGAN then
			switchScene("roost")
		end
	end,false,-131,false)
	
	this.layer = Mask:new({item = this.contentLayer})
	return this
end

function FightResult:getLayer()
	return self.layer
end

return FightResult