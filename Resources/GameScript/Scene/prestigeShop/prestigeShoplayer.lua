local PATH = IMG_SCENE.."preshop/"
local info_layer = require(SRC.."Scene/prestigeShop/InfoLayer")

local Shoplayer = {
	layer
}

function Shoplayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."main.jpg")
	setAnchPos(bg, 0, 0)
	this.layer:addChild(bg)
	
	local title = newSprite(PATH.."title.png")
	setAnchPos(title, 0, 674)
	this.layer:addChild(title)
	
	local shop = Btn:new(IMG_BTN, {"pre_shop.png", "pre_shop_press.png"}, 388, 665,{callback = function() 
		HTTPS:send("Shop" ,  
						{m="shop",a="shop",shop = "select"} ,
						{success_callback = function()
							switchScene("shop")
						end })
	end})
	this.layer:addChild(shop:getLayer())
	
	
	local scroll = ScrollView:new(0,90,480,575,5)
	local temp
	for k, v in pairs(DATA_PreShop:get()) do
		local temp
		temp = info_layer:new(v)
		scroll:addChild(temp:getLayer(),temp)
	end
	scroll:alignCenter()
	this.layer:addChild(scroll:getLayer())
	
	return this
end




function Shoplayer:getLayer()
	return self.layer
end


return Shoplayer
