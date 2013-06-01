local Detail = require(SRC.."Scene/common/CardDetail")
local CommEmbattle = {
	layer,
	scroll
}

function CommEmbattle:new(x, y, width, params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.params = params or {}
	this.layer = newLayer()
	
	this.scroll = ScrollView:new(x, y, width, 100, 5, true)
	
	this.layer:addChild(this.scroll:getLayer())
	
	local num = DATA_Embattle:getLen()
	if num < 6 then
		num = num + 1
	end
	local str, front, other
	for i = 1, num do
		local cid = DATA_Embattle:get(i,"cid")
		if cid then
			str = "icon_bg"..getBag("hero",cid , "star")..".png"
			front = IMG_ICON.."hero/S_"..getBag("hero", cid, "look")..".png"
			other = {IMG_COMMON.."icon_border"..getBag("hero", cid, "star")..".png", 45, 45}
		else
			str = "icon_lock.png"
			front = nil
			other = nil
		end
		local btn = Btn:new(IMG_COMMON, {str}, 100, 300, {
			front = front,
			other = other,
			callback = function()
				this.params.parent:addChild(Detail:new("hero", cid):getLayer(),1)
			end
		})
		if not cid then
			btn:setEnable(false)
		end
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