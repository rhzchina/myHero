local FightResult = {
	layer,
	contentLayer
}

function FightResult:new(result, hero, gift)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.contentLayer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."result_bg.png")
	setAnchPos(bg, 245, 420, 0.5, 0.5)
	this.contentLayer:addChild(bg)
	
	if result == 1 then
		bg = newSprite(IMG_COMMON.."lose.png")
	else
		bg = newSprite(IMG_COMMON.."win.png")
	end
	setAnchPos(bg, 245, 580, 0.5)
	this.contentLayer:addChild(bg)
	
	local gold = newSprite(IMG_COMMON.."gold_leaf.png")
	setAnchPos(gold,100, 530)
	this.contentLayer:addChild(gold)
	
	local silver = newSprite(IMG_COMMON.."silver.png")
	setAnchPos(silver,230,530)
	this.contentLayer:addChild(silver)
	
	local result = newSprite(IMG_COMMON.."s.png")	
	setAnchPos(result,330,520)
	this.contentLayer:addChild(result)
	
	local x, y = 60, 400
	for i = 1, table.nums(hero) do
		local btn = Btn:new(IMG_COMMON, {"icon_bg"..hero[i]["star"]..".png"}, x, y, {
			front = IMG_ICON.."hero/S_"..hero[i]["id"]..".png",
			other = {IMG_COMMON.."icon_border"..hero[i]["star"]..".png", 45, 45}
		})	
		this.contentLayer:addChild(btn:getLayer())
		
		x = x + btn:getWidth() * 1.5
		if i % 3 == 0 then
			x = 50
			y = y - btn:getHeight() * 1.2
		end
	end
	
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