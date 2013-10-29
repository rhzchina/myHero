local Dialog = {
	layer,
	params,
	str	
}

function Dialog:new(str, params)
	local this = {}
	setmetatable(this, self)
	self.__index = self
	
	this.params = params or {}
	this.str = str or ""
	this.layer = newLayer()
	this.layer:ignoreAnchorPointForPosition(false)
	
	local bg
	if this.params.bg then
		bg = newSprite(this.params.bg)
	else
		bg = newSprite(IMG_COMMON.."prompt_bg.png")
	end
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	this.layer:setContentSize(bg:getContentSize())
	setAnchPos(this.layer, 240, 425, 0.5, 0.5)
	
	local text = newLabel(str, 20, {
		color = this.params.color or ccc3(255, 255, 255),
		width = bg:getContentSize().width - (this.params.fontSize or 20) * 2,
	})
	setAnchPos(text, bg:getContentSize().width / 2, bg:getContentSize().height /2 , 0.5, 0.5)
	
	this.layer:addChild(text)
	
	return this
end

function Dialog:show()
	local scene = display.getRunningScene()
	self.layer:setScale(0)
	scene:addChild(self.layer)
	self.layer:runAction(getSequence(CCEaseElasticOut:create(CCScaleTo:create(0.8, 1)), CCDelayTime:create(self.params.delay or 0.5), CCCallFunc:create(function()
		self:remove()
	end)))
	
end

function Dialog:remove()
	local scene = display.getRunningScene()
	self.layer:runAction(getSequence(CCScaleTo:create(0.1, 0),CCCallFunc:create(function()
		scene:removeChild(self.layer, true)
	end)))
end

function Dialog.tip(str, params)
	local temp = Dialog:new(str, params)
	temp:show()
end

return Dialog