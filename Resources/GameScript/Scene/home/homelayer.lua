local PATH = IMG_SCENE.."home/"
local CommEmbattle = require(SRC.."Scene/common/CommEmbattle")

HomeLayer= {
}
function HomeLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.jpg")
	layer:addChild(bg)
	
	bg = newSprite(PATH.."function_bg.png")
	setAnchPos(bg, 240, 360, 0.5, 0.5)
	layer:addChild(bg)
	
	bg = newSprite(PATH.."embattle_bg.png")
	setAnchPos(bg, 0, 545)
	layer:addChild(bg)
	
		local embattle = CommEmbattle:new(45, 560, 390, {
		parent = layer
	})
	layer:addChild(embattle:getLayer())

	--底部按钮
	local main_small = {
	 	{"chat",20,
		 	function()
				 	switchScene("chat")
		 	end
	 	},
    	{"update",110,
    		function()
    			switchScene("update")
    		end},
	    {"athletics",200, function()
			   switchScene("athletics")  
	    end},
	    {"friend",290},
	    {"menu",380, function() pushScene("menu") end}
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
			   HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
				    switchScene("athletics", data)
			   end})
	    end},
	    {"fb",50,305},
		    {"explore",185,190, function()
		    HTTPS:send("Explore", {m = "explore", a = "explore", explore = "init"}, {success_callback = function(data)
			    switchScene("explore", data)
		    end})
	    end}
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
