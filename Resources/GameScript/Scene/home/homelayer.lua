local PATH = IMG_SCENE.."home/"
local CommEmbattle = requires(SRC.."Scene/common/CommEmbattle")

HomeLayer= {
	layer
}
function HomeLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self
	local temp = nil
	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.jpg")
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."function_bg.png")
	setAnchPos(bg, 240, 360, 0.5, 0.5)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."embattle_bg.png")
	setAnchPos(bg, 0, 545)
	this.layer:addChild(bg)
	
		local embattle = CommEmbattle:new(45, 560, 390, {
		parent = this.layer
	})
	this.layer:addChild(embattle:getLayer())
	

	--底部按钮
	local main_small = {
	 	{"chat",20,
		 	function()
				 	switchScene("chat")
		 	end
	 	},
    	{"update",110,
    		function()
				if tonumber(DATA_User:get("lv")) >= 10 then
					switchScene("update")
				else
					Dialog.tip("您需要10级才可开启！")
				end
    		end},
	    {"athletics",200, function()
			if tonumber(DATA_User:get("lv")) >= 15 then
				local sport_data = DATA_Sports:get_data()
				 if _G.next(sport_data) == nil then
						HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
							switchScene("athletics", data)
						end})
				 else
					switchScene("athletics")
				  end 
			else
				Dialog.tip("您需要15级才可开启！")
			end 
	    end},
	    {"friend",290,function() Dialog.tip("研发中，敬请期待!") end},
	    {"menu",380, function() pushScene("menu") end}
	}

	for i ,v in pairs(main_small) do
	    local temps = Btn:new(IMG_BTN,{v[1]..".png", v[1].."_press.png"}, v[2], 95, 
		    {
			   	callback = v[3]
		   	})
    	this.layer:addChild(temps:getLayer())
	end
	
	--中间按钮
	local mid_btn = {
	 	{"activity",185, 305,
	 		function()
	 			HTTPS:send("Activity", {activity = "open", a = "activity", m = "activity"}, {success_callback = function(data)
					switchScene("activity", data)
				end})
	 		end
	 	},
    	{"king",185,420,function()
    			HTTPS:send("Task" ,  
					{m="task",a="task",task = "map"} ,
					{success_callback = function()
						switchScene("roost")
					end })
    		end},
	    {"athletics",325,305, function()
			if tonumber(DATA_User:get("lv")) >= 15 then
				local sport_data = DATA_Sports:get_data()
				 if sport_data then
					
					 if _G.next(sport_data) == nil then
							HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
								switchScene("athletics", data)
							end})
					 else
						switchScene("athletics")
					 end
				 else
					switchScene("athletics")
				 end
			else
				Dialog.tip("您需要15级才可开启！")
			end
			 
			 
			   
	    end},
	    {"fb",50,305,function() 
			if tonumber(DATA_User:get("lv")) >= 30 then
				HTTPS:send("Duplicate", {m = "duplicate", a = "duplicate", duplicate = "open"}, {success_callback = function(data)
						switchScene("transcript",{type = 1})
				end})
			else
				Dialog.tip("您需要30级才可开启！")
			end
	
				
		end},
		    {"explore",185,190, function()
				if tonumber(DATA_User:get("lv")) >= 10 then
					HTTPS:send("Explore", {m = "explore", a = "explore", explore = "init"}, {success_callback = function(data)
						switchScene("explore", data)
					end})
				else
					Dialog.tip("您需要10级才可开启！")
				end
	    end}
	}

	for i ,v in pairs(mid_btn) do
	    local temps = Btn:new(PATH,{v[1]..".png", v[1].."_press.png"}, v[2], v[3], 
		    {
			   	callback = v[4]
		   	})
    	this.layer:addChild(temps:getLayer())
		if v[1] ==  "king" then
			temp= temps
		end
	end
	
	if Lead:getStep() == 1 then
		Lead:show(nil,{
			mask_clickable = true,
			x = -100,
			y = -100,
			width = 1,
			height = 1,
			offsetY = 300,
			callback = function()
				Lead:show(temp:getLayer(), {})
			end
		})
	end
	
    return this.layer
	
end







