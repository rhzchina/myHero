local PATH = IMG_SCENE.."home/"
local CommEmbattle = requires(SRC.."Scene/common/CommEmbattle")

HomeLayer= {
	layer
}
function HomeLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

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
    			switchScene("update")
    		end},
	    {"athletics",200, function()
			 local sport_data = DATA_Sports:get_data()
			 if _G.next(sport_data) == nil then
					HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
						switchScene("athletics", data)
					end})
			 else
				switchScene("athletics")
			  end 
	    end},
	    {"friend",290},
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
			 
			   
	    end},
	    {"fb",50,305,function() 
				HTTPS:send("Duplicate", {m = "duplicate", a = "duplicate", duplicate = "open"}, {success_callback = function(data)
						switchScene("transcript",{type = 1})
				end})
		end},
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
    	this.layer:addChild(temps:getLayer())
	end
	if GONGGAO == 0 then
		this:buySingle()
		GONGGAO = 1
	end
	
    return this.layer
end

function HomeLayer:buySingle()
	local mask 
	local data = DATA_Chat:get("announcement")
	
	local layer = newLayer()
	local bg = newSprite(IMG_COMMON.."announ.png")
	
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	local desc = newLabel("公告", 40, {x = 120, y = 565, dimensions=CCSizeMake(200, 60),color = ccc3(71, 31, 0)})
	layer:addChild(desc)
	
	local close_btn = Btn:new(IMG_BTN,{"close.png", "close_press.png"}, 390, 585, {
		priority = -131,
		callback = function()
			self.layer:removeChild(mask, true)
		end
	})
	layer:addChild(close_btn:getLayer())
	
	local sv = ScrollView:new(35,220,480,365,0,false)
	local temp_line = 1
	local layers = {}
	for k,v in pairs(data) do
		if layers[ temp_line ] == nil then
			layers[ temp_line ] = display.newLayer()
			layers[ temp_line ]:setContentSize( CCSizeMake(407 , 259) )
		end
		local tip_bg = newSprite(IMG_COMMON.."tip_bg.png")		
		
		layers[ temp_line ]:addChild(tip_bg)
		--标题
		local title = newLabel("标题："..v.name, 24, {x = 20, y = 210,color = ccc3(255, 255, 255)})
		layers[ temp_line ]:addChild(title)
		
		print(title:getContentSize().height)
		
		local content, line = createLabel({noFont = true, str = "内容："..v.content, size = 18, width = 360, color = ccc3(255, 255, 255)})
	
		setAnchPos(content,20,210 - title:getContentSize().height - 10 - (line * 18))
		
		layers[ temp_line ]:addChild(content)
		
		if tonumber(v.type) == 2 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
					HTTPS:send("Task" ,  
					{m="task",a="task",task = "map"} ,
					{success_callback = function()
						switchScene("roost")
					end })
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 3 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
					switchScene("update")
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 4 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
					HTTPS:send("Explore", {m = "explore", a = "explore", explore = "init"}, {success_callback = function(data)
						switchScene("explore", data)
					end})
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 5 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
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
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 6 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
					HTTPS:send("Duplicate", {m = "duplicate", a = "duplicate", duplicate = "open"}, {success_callback = function(data)
						switchScene("transcript")
					end})
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 7 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					self.layer:removeChild(mask, true)
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
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		end
		
		temp_line = temp_line + 1
			
		
	end
	
	for i = 1 , #layers do
		sv:addChild( layers[i] )
	end
	layer:addChild(sv:getLayer())
	
	
	mask = Mask:new({item = layer})
	self.layer:addChild(mask)
end