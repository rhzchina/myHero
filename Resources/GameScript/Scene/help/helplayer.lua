
local HelpLayer = {
	layer,
	mainlayer,
	otherlayer,
	help_data
}

function HelpLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	this.help_data = requires(CONFIG_PATH.."help")
	local bg = newSprite(IMG_PATH.."images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(IMG_TEXT.."help.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	this:createMain()
	
	return this
end

function HelpLayer: createMain()
	if self.otherlayer then
		self.layer:removeChild(self.otherlayer,true)
	end
	
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	self.mainlayer = CCLayer:create()

	local opt = {
		 {"help_hero", 0, 680, false, function() self:createOther("help_hero") end},
		 {"help_fight", 0, 580, false, function() self:createOther("help_fight") end},
		 {"help_shop", 0, 480, false, function() self:createOther("help_shop") end},
		 {"help_sports", 0, 380, false, function() self:createOther("help_sports") end}	
	}
		
	for i = 1, #opt do 
		local btn = Btn:new(IMG_BTN, {opt[i][1]..".png", opt[i][1].."_press.png"}, opt[i][2], opt[i][3], {
				other = opt[i][4] and {IMG_TEXT..opt[i][1]..".png", 60, -30},
				callback = opt[i][5],
		})
		self.mainlayer:addChild(btn:getLayer())
	end
		
		
	
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() switchScene("menu") end})
	self.mainlayer:addChild(back:getLayer())
	self.layer:addChild(self.mainlayer)
end

function HelpLayer: createOther(name)
	if self.mainlayer then
		self.layer:removeChild(self.mainlayer,true)
	end
	if self.otherlayer then
		self.layer:removeChild(self.otherlayer,true)
	end
	self.otherlayer = CCLayer:create()
	
	local btn = Btn:new(IMG_BTN, {name..".png", name..".png"}, 0, 680, {
				callback = function() end,
		})
	self.otherlayer:addChild(btn:getLayer())
	
	local text_context = self.help_data[name]
	
	local text, line = createLabel({noFont = true, str = text_context, size = 24, width = 440, color = ccc3(191,207,18)})
	
	setAnchPos(text,30,660 - (line * 24))
	
	self.otherlayer:addChild(text)
	local back = Btn:new(IMG_BTN, {"back_m.png", "back_m_press.png"}, 140, 23,{callback = function() self:createMain() end})
	self.otherlayer:addChild(back:getLayer())
	self.layer:addChild(self.otherlayer)
end

function HelpLayer:getLayer()
	return self.layer
end


return HelpLayer
