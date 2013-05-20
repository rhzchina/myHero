local CommEmbattle = {
	layer,
	scroll
}

function CommEmbattle:new(x, y, width)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = newLayer()
	
	this.scroll = ScrollView:new(x, y, width, 100, 5, true)
	
	this.layer:addChild(this.scroll:getLayer())
	
	for i = 1, 5 do
		local btn = Btn:new(IMG_COMMON, {"icon_bg2.png"}, 100, 300, {
		})
		this.scroll:addChild(btn:getLayer(), btn)
	end
	this.scroll:alignCenter()
	
	local turnBtn = Btn:new(IMG_BTN, {"left_big_normal.png", "left_big_press.png"}, 8, y + 3, {
	
	})
	this.layer:addChild(turnBtn:getLayer())
	
	turnBtn = Btn:new(IMG_BTN, {"right_big_normal.png", "right_big_press.png"}, x + width, y + 3, {
	
	})
	this.layer:addChild(turnBtn:getLayer())
	
	return this
end

function CommEmbattle:getLayer()
	return self.layer
end

return CommEmbattle