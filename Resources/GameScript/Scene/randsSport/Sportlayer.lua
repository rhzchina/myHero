--[[

登录框

]]
local MAIN = 1
local PATH = IMG_SCENE.."rand/"
local info_layer = require(SRC.."Scene/randsSport/InfoLayer")
local M = {
	baseLayer,
	layer	
}

function M:create( page )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.baseLayer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg, 0, 0)
	this.baseLayer:addChild(bg)
	
	local title = newSprite(PATH.."title_bg.png")
	setAnchPos(title,0,650)
	this.baseLayer:addChild(title)
	
	local btn = Btn:new(IMG_BTN, {"rand_bnt.png", "rand_bnt_press.png"}, 390, 650,{callback = function() 
	 HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
				    switchScene("athletics", data)
			   end})
	end})
	this.baseLayer:addChild(btn:getLayer())
	print("~~~~~~~~~~~~~~~")
	print(page)
	print("~~~~~~~~~~~~~~")
	
	
	local data = DATA_Rands:get_prestige()
	--[[
	
	for k,v in pairs(data)do
		if page == 0 then 
			
		else
		
		end
		dump(v)
	end
	
	]]
	local scroll = ScrollView:new(0,95,480,554,10)
		
		for k,v in pairs(data) do
			local temp = {}
			temp.page = page
			temp.num = k
			temp.icon_id = v["icon_id"]
			temp.name = v["Name"]
			temp.lv = v["lv"]
			temp.prestige = v["prestige"]
			local block = info_layer:new(temp)
			scroll:addChild(block:getLayer(),block)
		end
		scroll:alignCenter()
		scroll:setOffset(offset or 0)
		this.baseLayer:addChild(scroll:getLayer())
	--end
	
	
	return this
end



function M:getLayer()
	return self.baseLayer
end
return M
