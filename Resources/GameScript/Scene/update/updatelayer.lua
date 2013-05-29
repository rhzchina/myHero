local PATH = IMG_SCENE.."update/"
local Card = require(SRC.."Scene/common/CardInfo")

local UpdateLayer = {
	layer,
}

function UpdateLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	this.layer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	local group = RadioGroup:new()
	local upList = {
		{"hero", function()
				this:createHeroUp()
			end},
		{"card", function()
				this:createCardUp()
			end},
	}
	
	for i = 1, #upList do
		local heroUp = Btn:new(PATH, {upList[i][1].."_up.png", upList[i][1].."_up_select.png"},20 + (i - 1 ) * 160, 750, {
			callback = upList[i][2]
		},group)
		this.layer:addChild(heroUp:getLayer())		
	end
	group:chooseByIndex(2, true)
	
	local line = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(line, 0, 748)
	this.layer:addChild(line)
	
	
	return this
end

function UpdateLayer:createCardUp()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	
	self.contentLayer = newLayer()
	
	local card = Card:new(10, 400)
	self.contentLayer:addChild(card:getLayer())
	
	local bg = newSprite(PATH.."gold_bg.png")
	setAnchPos(bg, 280, 660)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."level_bg.png")
	setAnchPos(bg, 280, 530)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."gold_bg.png")
	setAnchPos(bg, 280, 430)
	self.contentLayer:addChild(bg)
	
	--选择目标卡牌
	local choose = Btn:new(PATH, {"choose_card.png", "choose_card_pre.png"}, 20, 310, {
	
	})
	self.contentLayer:addChild(choose:getLayer())
	
	--升级按钮
	local update = Btn:new(PATH, {"update.png", "update_pre.png"}, 250, 310, {
	
	})
	self.contentLayer:addChild(update:getLayer())
	
	--选择销毁卡牌
	local chooseItems = Btn:new(PATH, {"choose_item.png", "choose_item_pre.png"}, 20, 100, {
	
	})
	self.contentLayer:addChild(chooseItems:getLayer())
	
	--返回
	local back = Btn:new(PATH, {"back.png", "back_pre.png"}, 250, 100, {
		callback = function()
			switchScene("home")
		end
	})
	self.contentLayer:addChild(back:getLayer())
	
	
	local line = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(line, 0, 280)
	self.contentLayer:addChild(line)
	
	local scroll = ScrollView:new(0, 170, 480, 100, 10, true)
	
	for i = 1, 5 do
		local item = Btn:new(IMG_COMMON, {"icon_bg1.png"}, 0, 0,{
			other = {IMG_COMMON.."icon_border1.png", 45, 45}
		})
		scroll:addChild(item:getLayer(), item)
	end
	scroll:alignCenter()
	self.contentLayer:addChild(scroll:getLayer())
	
	
	
	self.layer:addChild(self.contentLayer)
end


function UpdateLayer:createHeroUp()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	
	self.contentLayer = newLayer()
	
	local card = Card:new(10, 400)
	self.contentLayer:addChild(card:getLayer())
	
	local bg = newSprite(PATH.."text_bg.png")
	setAnchPos(bg, 280, 680)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."text_bg.png")
	setAnchPos(bg, 280, 615)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."text_bg.png")
	setAnchPos(bg, 280, 550)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."text_bg.png")
	setAnchPos(bg, 280, 485)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."text_bg.png")
	setAnchPos(bg, 280, 420)
	self.contentLayer:addChild(bg)
	
	bg = newSprite(PATH.."up_info.png")
	setAnchPos(bg, 240, 200, 0.5)
	self.contentLayer:addChild(bg)
	
	local upStar = Btn:new(PATH, {"up_star.png", "up_star_pre.png"}, 20, 100, {
	
	})
	self.contentLayer:addChild(upStar:getLayer())
	
	local split = Btn:new(PATH, {"split.png", "split_pre.png"}, 250, 100, {
		callback = function()
		end
	})
	self.contentLayer:addChild(split:getLayer())
	
	self.layer:addChild(self.contentLayer)
end

function UpdateLayer:getLayer()
	return self.layer
end

return UpdateLayer
