InfoLayer= {
	layer,     --功能层
	topLayer,
}

local PATH = IMG_SCENE.."navigation/"

function InfoLayer:create(hideTop)
	local this={}
	setmetatable(this,self)
	self.__index = self
	
	--首页的元素拆分开
	this.layer = newLayer()
	
	local msgBg = newSprite(PATH.."msg_bg.png", 0, 854, 0, 1)
	this.layer:addChild(msgBg)
	
	if hideTop ~= true then
		this:createtop()
	end
	--底部的元素
	local bg = newSprite(PATH.."navigation_bottom.png")
	this.layer:addChild(bg)

	local group = RadioGroup:new()
	local buttom_array = {
		{"home",
			function()
				switchScene("home")
			end
		},
		

	    {"embattle",
	    	function()
	    		HTTPS:send("Battle" , 
		    		{m="battle",a="battle",battle = "select_up"} ,
		    		{success_callback = function()
						switchScene("lineup")
					end })
	    	end
	    },
	    {"bag",
			function()
			 	switchScene("bag")
			end
		},
		{"king",
			function()
				HTTPS:send("Task" ,  
					{m="task",a="task",task = "map"} ,
					{success_callback = function()
						switchScene("roost")
					end })
			end
		},
		{"fb",
			function()
			end
		},
	
		{"shop",
			function()
			end
		}
	}

	local x = 10
	for i , v in pairs(buttom_array) do
		local temp = Btn:new(IMG_BTN, {v[1]..".png",v[1].."_press.png"}, x, 0,
			{
				callback = v[2],
			    scale = true,
			    selectable=select
			})
		this.layer:addChild(temp:getLayer())
		x = x + 78
	end
    return this
end

function InfoLayer:getLayer()
	return self.layer
end

function InfoLayer:createtop()
	if self.topLayer then
		self.layer:removeChild(self.topLayer,true)
	end
	
	self.topLayer = newLayer()

	local bg = newSprite(PATH.."navigation_top.png")
	self.topLayer:addChild(bg)
	self.topLayer:setContentSize(bg:getContentSize())
	setAnchPos(self.topLayer, 0, 854 - 50 - bg:getContentSize().height)
	self.layer:addChild(self.topLayer)

	--等级
--	local leve  = newSprite(PATH.."level_bg.png", 12, 20)
--	self.topLayer:addChild(leve)
	local level = Progress:new(PATH,{"exp_bg.png", "exp.png"}, 60, 20, {
		cur = 50,
		leftIcon = {"level_bg.png",18,28}
	})
	self.topLayer:addChild(level:getLayer())
	level = newLabel(DATA_User:get("Gold"),  20, {x = 23, y = 35})
	self.topLayer:addChild(level)

	--用户名
	local label_user = newLabel(DATA_User:get("name"), 26, {x = 140, y = 55, ax = 0.5})
	self.topLayer:addChild(label_user)
	
	local gas  = newSprite(PATH.."gas_bg.png", 345, 15)
	self.topLayer:addChild(gas)
	gas = newLabel(DATA_User:get("energy"), 20, {x = 415, y = 20, ax = 0.5})--体力值
	self.topLayer:addChild(gas)
	
	
	local silver  = newSprite(PATH.."silver_bg.png", 220, 55)--银两
	self.topLayer:addChild(silver)
	silver = newLabel(DATA_User:get("Money"), 20, {x = 290, y = 60, ax = 0.5})--体银两
	self.topLayer:addChild(silver)
	
	local goldLeaf  = newSprite(PATH.."gold_bg.png", 345, 55)--金叶子
	self.topLayer:addChild(goldLeaf)
	goldLeaf = newLabel(DATA_User:get("Coin"),  20, {x = 415, y = 60, ax = 0.5})--金叶子
	self.topLayer:addChild(goldLeaf)
	
	local power  = newSprite(PATH.."power_bg.png", 220, 15)
	self.topLayer:addChild(power)
	power = newLabel(DATA_User:get("PhysicalValue"), 20, {x = 290, y = 20, ax = 0.5})--气
	self.topLayer:addChild(power)
end

return InfoLayer
