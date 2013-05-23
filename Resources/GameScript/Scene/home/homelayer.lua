local PATH = IMG_SCENE.."home/"
local CommEmbattle = require(SRC.."Scene/common/CommEmbattle")
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
	
	local embattle = CommEmbattle:new(45, 535, 390)
	layer:addChild(embattle:getLayer())

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
	 	{"activity",185, 295,
	 		function()
	 			--加武器
--	 			HTTPS:send("Skill",{m="skill",a="skill",skill="arm_add",id=6203},{})
--加英雄
	 			HTTPS:send("AddHero",{m="heros",a="heros",heros="add",star=5},{})

--	 			HTTPS:send("Skill",{m="skill",a="skill",skill="add",star=5},{})
	 		end
	 	},
    	{"king",185,400,function()
    			HTTPS:send("Task" ,  
					{m="task",a="task",task = "map"} ,
					{success_callback = function()
						switchScene("roost")
					end })
    		end},
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
