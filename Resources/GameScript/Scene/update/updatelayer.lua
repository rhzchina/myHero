local PATH = IMG_SCENE.."update/"
local Card = require(SRC.."Scene/common/CardInfo")
local List = require(SRC.."Scene/common/ItemList")

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
			callback = upList[i][2],
			disableWhenChoose = true,
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
		callback = function()
			local list
			list = List:new({
				type = {"hero", "equip"},
				
			})
			self.layer:addChild(list:getLayer())
		end
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


function UpdateLayer:createHeroUp(cid, data)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	self.contentLayer = newLayer()
	local use = {
		{"魂魄白 x", DATA_User:get("soul_w"),data and data["condition"]["exp_w"] or ""},
		{"魂魄蓝 x", DATA_User:get("soul_b"),data and data["condition"]["exp_b"] or ""},
		{"魂魄金 x", DATA_User:get("soul_g"),data and data["condition"]["exp_g"] or ""},
	}
	
	for i = 1, #use do
		local t = newLabel(use[i][1]..use[i][2], 20, {x =  35 + 150 * (i - 1), y = 710}) 
		self.contentLayer:addChild(t)
	end
	
	local card = Card:new(10, 350, {
		type = "hero",
		cid = cid,
		callback = function()
		local list 
		list = List:new({
			type = "hero",
			checkBoxOpt = function()
				print(list:getSelectId())
			end,
			okCallback = function()
				HTTPS:send("Strong", {a = "hero", m = "strong", 
					strong = "get", 
					id = getBag("hero", list:getSelectId(), "id") , 
					cid = list:getSelectId()},{
					success_callback = function(rec)
						dump(rec)
						self:createHeroUp(list:getSelectId(), rec)
					end}
				)
			end
		})	
		self.layer:addChild(list:getLayer())
	end})
	self.contentLayer:addChild(card:getLayer())
	
	local info = {
		{"星级:", "star"},
		{"等级:", "lev"},
		{"攻击:", "att"},
		{"防御:", "defe"},
		{"血量:", "hp"},
	}
	local bg, text
	for i = 1, 5 do
		bg = newSprite(PATH.."text_bg.png")
		setAnchPos(bg, 280, 630 - 65 * (i - 1))
		self.contentLayer:addChild(bg)
		
		text = newLabel(info[i][1], 18, {x = 285, y = 645 - 65 * (i - 1)})
		self.contentLayer:addChild(text)
		
		if cid then
			text = newLabel(getBag("hero", cid, info[i][2]).." - "..data["strong"]["chan_"..info[i][2]], 18, {x = 395, y = 645 - 65 * (i - 1), ax = 0.5})
			self.contentLayer:addChild(text)
		end
	end
	
	bg = newSprite(PATH.."up_info.png")
	setAnchPos(bg, 240, 170, 0.5)
	self.contentLayer:addChild(bg)
	
	text = newLabel("升级条件", 25, {x = 240, y = 290, ax = 0.5})
	self.contentLayer:addChild(text)
	
	if cid then
		for i = 1, #use do
			text = newLabel(use[i][1]..use[i][3], 20, {x = 20 + (i - 1) * 150, y = 240})
			self.contentLayer:addChild(text)
		end
		
		text = newSprite(IMG_COMMON.."silver.png")
		setAnchPos(text, 190, 190)
		self.contentLayer:addChild(text)
		
		text = newLabel(data["condition"]["money"], 25, {x = 230, y = 185})
		self.contentLayer:addChild(text)
	end
	
	
	
	
	
	local upStar = Btn:new(PATH, {"up_star.png", "up_star_pre.png"}, 20, 95, {
	
	})
	self.contentLayer:addChild(upStar:getLayer())
	
	local split = Btn:new(PATH, {"split.png", "split_pre.png"}, 250, 95, {
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
