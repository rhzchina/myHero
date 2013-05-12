local PATH = IMG_SCENE.."home/"
HomeLayer= {
}
function HomeLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	layer:addChild(bg)
	
	bg = newSprite(PATH.."function_bg.png")
	setAnchPos(bg, 240, 350, 0.5, 0.5)
	layer:addChild(bg)
	
	bg = newSprite(PATH.."embattle_bg.png")
	setAnchPos(bg, 0, 505)
	layer:addChild(bg)

	--底部按钮
	local main_small = {
	 	{"chat",20,
	 	},
    	{"update",110},
	    {"athletics",200},
	    {"friend",290},
	    {"menu",380}
	}

	for i ,v in pairs(main_small) do
	    local temps = Btn:new(IMG_BTN,{v[1]..".png", v[1].."_press.png"}, v[2], 95, 
		    {
			   	callback = v[3]
		   	})
    	layer:addChild(temps:getLayer())
	end
	
	--中间按钮
	local mid_btn = {
	 	{"activity",185, 295
	 	},
    	{"king",185,400},
	    {"athletics",325,295},
	    {"fb",50,295},
	    {"explore",185,180}
	}


	for i ,v in pairs(mid_btn) do
	    local temps = Btn:new(PATH,{v[1]..".png", v[1].."_press.png"}, v[2], v[3], 
		    {
			   	callback = v[4]
		   	})
    	layer:addChild(temps:getLayer())
	end

    return layer
end
