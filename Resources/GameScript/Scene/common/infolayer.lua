InfoLayer= {
	layer,     --功能层
}


function InfoLayer:create(layerName)
	local this={}
	setmetatable(this,self)
	self.__index = self
	
	--首页的元素拆分开
	this.layer = CCLayer:create()

	local bg = newSprite("image/scene/home/Navigation_bg.png")
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
	    		HTTPS:send("Battle" ,  {m="Battle",a="Battle",Battle = "select_up"} ,{success_callback = function()
								switchScene("LineUp")
							end })
	    	end
	    },
		{"practice",
			function()
				HTTPS:send("Task" ,  {m="Task",a="map",task = "map"} ,{success_callback = function()
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
