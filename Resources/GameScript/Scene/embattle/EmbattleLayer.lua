--英雄上阵
local Card = require(SRC.."Scene/common/CardInfo")
local EmbattleLayer= {
	layer,  --信息头
	contentLayer,
	data
}

function EmbattleLayer:new()
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."main.jpg")
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	local btn = Btn:new(IMG_BTN,{"btn_bg.png", "btn_bg_press.png"}, 20 ,110, {
		front = IMG_TEXT.."save.png",
		callback = function()
			HTTPS:send("Battle",{m = "battle", a = "battle", battle = "replace",data = this.data},{
				success_callback=function()
					print("换位了")
				end})
		end
	})
	this.layer:addChild(btn:getLayer())
	
	btn = Btn:new(IMG_BTN,{"btn_bg.png", "btn_bg_press.png"}, 250 ,110, {
		front = IMG_TEXT.."back.png",
		callback = function()
			switchScene("lineup")
		end
	})
	this.layer:addChild(btn:getLayer())
	

	this:createEmbattle()
	return this
end

function EmbattleLayer:createEmbattle(curData,pos)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer,true)
	end
	self.contentLayer = newLayer()
	
	local select = newSprite(IMG_COMMON.."select.png")
	self.contentLayer:addChild(select,5)	
	
	local x, y = 10, 500
	local cur = pos or 1
	self.data = curData or DATA_Embattle:get()
	for i = 1, table.nums(self.data) do
		local card 
		card = Card:new(x, y, {type = "hero", scaleX = 0.55, scaleY = 0.55,cid = self.data[i]["cid"],
			callback = function()
				cur = i
				select:setPosition(card:getLayer():getPositionX() - 3, card:getLayer():getPositionY() - 3)
			end
		})
		self.contentLayer:addChild(card:getLayer())
		
		if i == cur then
			select:setPosition(card:getLayer():getPositionX() - 3, card:getLayer():getPositionY() - 3)
		end
		
		local switch = Btn:new(IMG_BTN, {"switch.png", "switch_press.png"}, x + 20, y - 45, {
			callback = function()
				if cur ~= i then
					local t = self.data[cur]
					self.data[cur] = self.data[i]
					self.data[i] = t
					self:createEmbattle(self.data, i)
				end
			end
		})
		self.contentLayer:addChild(switch:getLayer())
		x = x + card:getWidth() * 1.1
		if i  % 3 == 0 then
			x = 10
			y = y - card:getHeight() * 1.4
		end
	end
	
	self.layer:addChild(self.contentLayer)
end

function EmbattleLayer:getLayer()
	return self.layer
end

return EmbattleLayer
