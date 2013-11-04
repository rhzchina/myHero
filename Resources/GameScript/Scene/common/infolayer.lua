GLOBAL_INFOLAYER = nil
InfoLayer= {
	layer,     --功能层
	topLayer,
	userinfoLayer
}

local PATH = IMG_SCENE.."navigation/"
requires(SRC.."Scene/common/userinfo")
function InfoLayer:create(hideTop)
	local this={}
	setmetatable(this,self)
	self.__index = self
	
	local lead 
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
	    		if DATA_Dress:isLegal() then
					switchScene("lineup")
	    		else
	    			HTTPS:send("Skill" , 
		    		{m="skill",a="skill",skill = "selectline"} ,
		    		{success_callback = function()
						switchScene("lineup")
					end })
	    		end
	    		
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
				if tonumber(DATA_User:get("lv")) >= 30 then
					HTTPS:send("Duplicate", {m = "duplicate", a = "duplicate", duplicate = "open"}, {success_callback = function(data)
						switchScene("transcript",{type = 1})
					end})
				else
					Dialog.tip("您需要30级才可开启！")
				end
				
			end
		},
	
		{"shop",
			function()
				if DATA_Shop:isLegal() then
					switchScene("shop")
				else
					HTTPS:send("Shop" ,  
						{m="shop",a="shop",shop = "select"} ,
						{success_callback = function()
							switchScene("shop")
						end })
				end
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
		
		if v[1] == "home" then
			lead = temp
		end
	end
	GLOBAL_INFOLAYER = this
--	
--	if Lead:getStep() == 4 then
--		Lead:show(nil, {
--			x = -100,
--			y = 0,
--			width = 0,
--			height = 0,
--		})
--	end
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
	setAnchPos(self.topLayer, 0, 854 - 44 - bg:getContentSize().height)
	self.layer:addChild(self.topLayer)

	local btn_rect = CCRectMake(0 , 854 - 44 - bg:getContentSize().height , bg:getContentSize().width , bg:getContentSize().height)
	--等级
--	local leve  = newSprite(PATH.."level_bg.png", 12, 20)
--	self.topLayer:addChild(leve)
	local cur = math.floor(tonumber(DATA_User:get("Exp"))/tonumber(DATA_User:get("Next_Exp")))
	local show_cur = 0
	if cur > 0 then
		show_cur = cur
	else
	
	end
	
	local level = Progress:new(PATH,{"exp_bg.png", "exp.png"}, 60, 20, {
		cur = show_cur,
		leftIcon = {"level_bg.png",18,28}
	})
	self.topLayer:addChild(level:getLayer())
	level = newLabel(DATA_User:get("lv"),  30, {x = 48, y = 30, ax = 0.5})
	self.topLayer:addChild(level)

	--用户名
	local label_user = newLabel(DATA_User:get("name"), 26, {x = 140, y = 55, ax = 0.5})
	self.topLayer:addChild(label_user)
	
	local gas  = newSprite(PATH.."gas_bg.png", 345, 15)
	self.topLayer:addChild(gas)
	
	
	
	local silver  = newSprite(PATH.."silver_bg.png", 220, 55)--银两
	self.topLayer:addChild(silver)
	local money = math.floor(tonumber(DATA_User:get("Money"))/10000)
	if money > 0 then
		silver = newLabel(money .."万", 20, {x = 290, y = 60, ax = 0.5})--体银两
	else
		silver = newLabel(DATA_User:get("Money"), 20, {x = 290, y = 60, ax = 0.5})--体银两
	end
	
	self.topLayer:addChild(silver)
	
	local goldLeaf  = newSprite(PATH.."gold_bg.png", 345, 55)--金叶子
	self.topLayer:addChild(goldLeaf)
	
	local Gold = math.floor(tonumber(DATA_User:get("Gold"))/10000)
	if Gold > 0 then
		goldLeaf = newLabel(Gold.."万",  20, {x = 415, y = 60, ax = 0.5})--金叶子
	else
		goldLeaf = newLabel(DATA_User:get("Gold"),  20, {x = 415, y = 60, ax = 0.5})--金叶子
	end
	
	
	self.topLayer:addChild(goldLeaf)
	
	local power  = newSprite(PATH.."power_bg.png", 220, 15)
	self.topLayer:addChild(power)
	local prestige = math.floor(tonumber(DATA_User:get("prestige"))/10000)
	if prestige > 0 then
		power = newLabel(prestige.."万", 20, {x = 415, y = 20, ax = 0.5})--气
	else
		power = newLabel(DATA_User:get("prestige"), 20, {x = 415, y = 20, ax = 0.5})--气
	end
	self.topLayer:addChild(power)
	
	
	local energy = math.floor(tonumber(DATA_User:get("energy"))/10000)
	if energy > 0 then
		gas = newLabel(energy.."万", 20, {x = 280, y = 20, ax = 0.5})--体力值
	else
		gas = newLabel(DATA_User:get("energy"), 20, {x = 280, y = 20, ax = 0.5})--体力值
	end
	
	
	self.topLayer:addChild(gas)
	
	local btn_progress = false
	local function onTouch(eventType , x , y)
		if eventType == CCTOUCHBEGAN then
			if btn_rect:containsPoint( ccp(x , y) ) then
				
				local scene = display.getRunningScene()
				if self.userinfoLayer then
					scene:removeChild(self.userinfoLayer,true)
				end
				self.userinfoLayer = UserInfoLayer:create():getLayer()
				
				scene:addChild(self.userinfoLayer)
			end
			return true
		end
		return true
	end
	self.topLayer:registerScriptTouchHandler(onTouch)
    self.topLayer:setTouchEnabled(true)
	
end

return InfoLayer
