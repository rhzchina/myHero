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
	
	local cid, str
	for i = 1, DATA_Embattle:getLen() do
		cid = DATA_Embattle:get(i,"cid")
		str = "icon_bg"..getBag("hero",cid , "star")..".png"
		local btn = Btn:new(IMG_COMMON, {str}, 100, 300, {
			front = IMG_ICON.."hero/S_"..getBag("hero", cid, "look")..".png",
			other = {IMG_COMMON.."icon_border"..getBag("hero", cid, "star")..".png", 45, 45}
		})
		this.scroll:addChild(btn:getLayer(), btn)
	end
	this.scroll:alignCenter()
	
	local turnBtn = Btn:new(IMG_BTN, {"left_big_normal.png", "left_big_press.png"}, 8, y + 3, {
	
	})
	turnBtn:setPosition(x - turnBtn:getWidth(),y + 3)
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