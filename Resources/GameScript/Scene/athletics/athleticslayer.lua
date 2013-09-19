local PATH = IMG_SCENE.."athletics/"

local AthleticsLayer= {
	layer,	
	contentLayer,
	data,
	listlayer
}
function AthleticsLayer:create(data)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.data = data or {}
	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.jpg")
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."role_bg.png")
	setAnchPos(bg, 0, 545)
	this.layer:addChild(bg)
	
	
	local refresh = Btn:new(IMG_BTN, {"refresh.png", "refresh_press.png"}, 400, 580, {
		callback = function()
			HTTPS:send("Sports",
	    						{a = "sports",
	    						 m = "sports", 
	    						 sports = "refresh"
	    						 },{success_callback= function(back_data)
										DATA_Sports:set_data(back_data["data"])
										DATA_Sports:set_time(back_data["time"])  
										this:createRecord()	
	
										this:createContent()
	    						 end
	    						 })
		end
	})
	this.layer:addChild(refresh:getLayer())
	
	
	this:createRecord()	
	
	this:createContent()
	
	
    return this.layer
end

function AthleticsLayer:createRecord()	 
	 if self.listlayer then
		self.layer:removeChild(self.listlayer,true)
	end
	self.listlayer = CCLayer:create()
	local record_data = DATA_Sports:get_record()
	local time_data = DATA_Sports:get_time()
	local sv = ScrollView:new(0,70,480,475,0,false)
	if _G.next(record_data) ~= nil then
		
		local temp_line = 1
		local layers = {}
		for k,v in pairs(record_data)do
			if layers[ temp_line ] == nil then
				layers[ temp_line ] = display.newLayer()
				layers[ temp_line ]:setContentSize( CCSizeMake(480 , 114) )
			end
			
			if tonumber(v.type) == 0 then
				local bg = newSprite(PATH.."result_bg.png")
				layers[ temp_line ]:addChild(bg)
				
				local lost = newSprite(PATH.."lost.png")
				setAnchPos(lost, 20, (114 - 41)/2)
				layers[ temp_line ]:addChild(lost)
				
				layers[ temp_line ]:addChild(newLabel("你对"..v.name.."发起\n了挑战你获胜了", 24, {x = 130, y = (114 - 50)/2, color = ccc3(255, 0, 0)}))
				local lost_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, (114 - 4)/2, {
	
				})
				
				layers[ temp_line ]:addChild(lost_view:getLayer())
				
				local revenge = Btn:new(IMG_BTN, {"revenge.png", "revenge_press.png"}, 380, (114 - 104)/2, {
					callback = function() 
						HTTPS:send("Fighting",
	    						{a = "fighting",
	    						 m = "fighting", 
	    						 fighting = "start", 
	    						 type = "sports",
	    						 s_id = v.sid, 
	    						 },{success_callback= function()
	    						 	switchScene("fighting")
	    						 end
	    						 })
					end
				})
				layers[ temp_line ]:addChild(revenge:getLayer())
			elseif tonumber(v.type) == 1 then
				local bg = newSprite(PATH.."result_bg.png")
				layers[ temp_line ]:addChild(bg)
				
				local win = newSprite(PATH.."win.png")
				setAnchPos(win, 20, (114 - 41)/2)
				layers[ temp_line ]:addChild(win)
				
				layers[ temp_line ]:addChild(newLabel("你对"..v.name.."发起\n了挑战你失败了", 24, {x = 130, y = (114 - 50)/2, color = ccc3(255, 0, 0)}))
				local lost_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, (114 - 50)/2, {
	
				})
				layers[ temp_line ]:addChild(lost_view:getLayer())
			end
			
			temp_line = temp_line + 1
		end
		
		for i = 1 , #layers do
			sv:addChild( layers[i] )
		end
		
		local other_layer = nil
		other_layer = display.newLayer()
		other_layer:setContentSize( CCSizeMake(480 , 114) )
		other_layer:addChild(newLabel("我的声望:"..DATA_User:get("prestige"), 24, {x = 50, y = 60, color = ccc3(0, 0, 0)}))
		other_layer:addChild(newLabel("我的排名:"..time_data.top, 24, {x = 250, y = 60, color = ccc3(0, 0, 0)}))
		if tonumber(time_data.istime) == 0 then
			other_layer:addChild(newLabel("冷却时间:0", 24, {x = 50, y = 10, color = ccc3(0, 0, 0)}))
		else
			other_layer:addChild(newLabel("冷却时间:"..tonumber(time_data.time), 24, {x = 50, y = 10, color = ccc3(0, 0, 0)}))
		end
		
		other_layer:addChild(newLabel("今日剩余挑战次数:"..time_data.challenge_num, 24, {x = 50, y = -40, color = ccc3(0, 0, 0)}))
		
		local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, -110, {
			callback = function()
				HTTPS:send("Exploreshop" ,{m="exlploreshop",a="exlploreshop",exlploreshop= "open"} ,{success_callback = 
						function()
							switchScene("prestigeShop")
				end })
			end
		})
		other_layer:addChild(shop:getLayer())
		
		local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, -110, {
			callback = function()
				HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=0} ,{success_callback = 
						function()
							switchScene("randsSport",0)
				end })
			end
		})
		other_layer:addChild(rank:getLayer())
		
		sv:addChild(other_layer)
		self.listlayer:addChild(sv:getLayer())	
	else
		self.listlayer:addChild(newLabel("我的声望:"..DATA_User:get("prestige"), 24, {x = 50, y = 260, color = ccc3(0, 0, 0)}))
		self.listlayer:addChild(newLabel("我的排名:"..time_data.top, 24, {x = 250, y = 260, color = ccc3(0, 0, 0)}))
		if tonumber(time_data.istime) == 0 then
			self.listlayer:addChild(newLabel("冷却时间:0", 24, {x = 50, y = 210, color = ccc3(0, 0, 0)}))
		else
			self.listlayer:addChild(newLabel("冷却时间:"..tonumber(time_data.time), 24, {x = 50, y = 210, color = ccc3(0, 0, 0)}))
		end
		
		self.listlayer:addChild(newLabel("今日剩余挑战次数:"..time_data.challenge_num, 24, {x = 50, y = 160, color = ccc3(0, 0, 0)}))
		
		local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, 90, {
			callback = function()
				HTTPS:send("Exploreshop" ,{m="exlploreshop",a="exlploreshop",exlploreshop= "open"} ,{success_callback = 
						function()
							switchScene("prestigeShop")
				end })
			end
		})
		self.listlayer:addChild(shop:getLayer())
		
		local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, 90, {
			callback = function()
				HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=0} ,{success_callback = 
						function()
							switchScene("randsSport",0)
				end })
			end
		})
		self.listlayer:addChild(rank:getLayer())
		
	end
	
	
	self.layer:addChild(self.listlayer)
end

function AthleticsLayer:createContent()
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer,true)
	end	
	
	self.contentLayer = newLayer()
	
	local scroll = ScrollView:new(10, 555, 380, 150, 20, true)
	self.contentLayer:addChild(scroll:getLayer())
	local hero_data = DATA_Sports:get_data()
	if hero_data then
		for k, v in pairs(hero_data) do
			local other = Btn:new(PATH, {"bg_green.png", "bg_blue.png"}, 0, 0, {
				other = {{IMG_COMMON.."icon_bg1.png", 53, 90},{IMG_ICON.."hero/S_2301.png", 53, 90}, {IMG_COMMON.."icon_border1.png", 53, 90}},
				text = {{"Lv "..v.lv, 20, ccc3(255,255,255), ccp(0, -45)}, {v.Name, 20, ccc3(255,255,255), ccp(0, -67)}},
				callback = function()
					HTTPS:send("Fighting",
									{a = "fighting",
									 m = "fighting", 
									 fighting = "start", 
									 type = "sports",
									 s_id = v.Id, 
									 },{success_callback= function()
										switchScene("fighting")
									 end
									 })
				end
			})
			scroll:addChild(other:getLayer())
		end
	end
	
	
	
	self.layer:addChild(self.contentLayer)	
end

return AthleticsLayer