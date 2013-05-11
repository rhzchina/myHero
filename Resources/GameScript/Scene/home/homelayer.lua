
HomeLayer= {
}
function HomeLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	layer:addChild(bg)
	layer:setPosition(ccp(x,y))

	local main_small = {
	 	{"luggage",20,
		 	function()
			 	switchScene("bag")
		 	end
	 	},
    	{"exp",110},
	    {"travel",200},
	    {"conquer",290},
	    {"strengthen",380}
	}

	--local group = RadioGroup:new()

	for i ,v in pairs(main_small) do
	    local temps = Btn:new(IMG_BTN,{v[1].."_normal.png", v[1].."_press.png"}, v[2], 100, 
		    {
			   	callback = v[3]
		   	})
    	layer:addChild(temps:getLayer())
	end

    return layer
end
