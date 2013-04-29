InfoLayer= {
	layer,     --功能层
}


function InfoLayer:create(layerName)
	local this={}
	setmetatable(this,self)
	self.__index = self
	
	--首页的元素拆分开
	this.layer = CCLayer:create()

	local bg = CCSprite:create("image/scene/home/Navigation_bg.png")
	bg:setAnchorPoint(ccp(0,0))
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
	    		HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "select_up",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene("LineUp")
							end })
	    	end
	    },
		{"practice",
			function()
				HTTPS:send("Task" ,  {m="Task",a="map",task = "map",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene("roost")
							end })
			end
		},
		{"plunder",
			function()
			end
		},
		{"king",
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

function InfoLayer:getMainView()
	return self.layer
end

return InfoLayer
