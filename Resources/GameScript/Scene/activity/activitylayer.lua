local PATH = IMG_SCENE.."activity/"

local ActivityLayer= {
	layer,	
	contentLayer
}
function ActivityLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	this.layer:addChild(bg)
	
	
	this:loginGift()	
    return this.layer
end

function ActivityLayer:loginGift()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	self.contentLayer = newLayer()
	
	local bg = newSprite(PATH.."login_gift.png")
	setAnchPos(bg, 0, 680)
	self.contentLayer:addChild(bg)
	
	local scroll = ScrollView:new(0, 90, 480, 590)
	self.contentLayer:addChild(scroll:getLayer())
	
	for i = 1, 7 do
		local layer = newLayer()
		local bg = newSprite(PATH.."gift_bg.png")
		layer:setContentSize(bg:getContentSize())
		layer:addChild(bg)
		
		local btn = Btn:new(IMG_BTN, {"get.png", "get_press.png"}, 290, 35, {
			parent = scroll
		})
		layer:addChild(btn:getLayer())
--		
		local text = newLabel("第"..i.."天", 20,{x = 180, y = 60, color = ccc3(0x2c, 0, 0)})
		layer:addChild(text)
		
		local gift = Btn:new(IMG_COMMON,{"icon_bg".."1"..".png"}, 50, 20, {
			front = IMG_ICON.."equip".."/S_".."5101"..".png",
			other = {IMG_COMMON.."icon_border".."1"..".png",45,45},
			parent = scroll,
		})
		layer:addChild(gift:getLayer())
		
		scroll:addChild(layer)
	end	
	scroll:alignCenter()
	
	
	self.layer:addChild(self.contentLayer)
end
return ActivityLayer