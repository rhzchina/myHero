local PATH = IMG_SCENE.."athletics/"

local AthleticsLayer= {
	layer,	
	contentLayer,
	data,
	listlayer,
	time_data
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
			if tonumber(this.time_data.time) == 0 then
				if tonumber(this.time_data.free_num) == 0 then
					this.layer:addChild(ShowDialog:create("您是否花2代币刷新用户列表!",{
						success_callback = function()
							HTTPS:send("Sports",
							{a = "sports",
							 m = "sports", 
							 sports = "refresh"
							 },{success_callback= function(back_data)
									if back_data["data"] then
										DATA_Sports:set_data(back_data["data"])
										this:createContent()
									end
									if back_data["time"] then
										DATA_Sports:set_time(back_data["time"])
										this:createRecord()	
									end
							 end
							 })
						end
					}):getLayer())
				else
					HTTPS:send("Sports",
							{a = "sports",
							 m = "sports", 
							 sports = "refresh"
							 },{success_callback= function(back_data)
									if back_data["data"] then
										DATA_Sports:set_data(back_data["data"])
										this:createContent()
									end
									
									if back_data["time"] then
										DATA_Sports:set_time(back_data["time"])
										this:createRecord()	
									end
									
							 end
							 })
				end
			else
				Dialog.tip("冷却时间未到，请清除冷却时间")
			end
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
	local scheduler = nil
	local time_back = nil
	local time_label = nil
	local clear = nil
	local other_layer = nil
	local record_data = DATA_Sports:get_record()
	self.time_data = DATA_Sports:get_time()
	local function time_back_function()
			local cur_scene = display.getRunningScene().name
			if cur_scene ~= "athletics" then
				scheduler:unscheduleScriptEntry(time_back)
			end
			
			self.time_data.time = self.time_data.time  - 1
			if tonumber(self.time_data.time) <= -1 then
				self.time_data.time = 0			
				if clear then
					other_layer:removeChild(clear:getLayer(),true)
				end
				scheduler:unscheduleScriptEntry(time_back)
			end
			if tonumber(self.time_data.time) >= 0 then
				if time_label then
					time_label:setString("冷却时间:"..math.floor(tonumber(self.time_data.time)/60)..":"..(tonumber(self.time_data.time)%60))
				else
					scheduler:unscheduleScriptEntry(time_back)
				end
			end	
	end
	
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
				
				local win = newSprite(PATH.."win.png")
				setAnchPos(win, 20, (114 - 41)/2)
				layers[ temp_line ]:addChild(win)
				
				layers[ temp_line ]:addChild(newLabel("你对"..v.name.."发起\n了挑战你胜利了", 24, {x = 130, y = (114 - 50)/2, color = ccc3(255, 0, 0)}))
				local lost_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, (114 - 50)/2, {
					callback = function()
						if tonumber(self.time_data.time) == 0 and tonumber(v.num) > 0 then
							HTTPS:send("Sports" ,{m="sports",a="sports",sports= "check",s_id=v.sid} ,{success_callback = 
								function()
									if scheduler then
										scheduler:unscheduleScriptEntry(time_back)
									end
									switchScene("fighting","sport")
							end })
						else
							Dialog.tip("冷却时间未到，请清除冷却时间")
						end
						
					end
				})
				layers[ temp_line ]:addChild(lost_view:getLayer())				
			elseif tonumber(v.type) == 1 then				
				local bg = newSprite(PATH.."result_bg.png")
				layers[ temp_line ]:addChild(bg)
				
				local lost = newSprite(PATH.."lost.png")
				setAnchPos(lost, 20, (114 - 41)/2)
				layers[ temp_line ]:addChild(lost)
				
				layers[ temp_line ]:addChild(newLabel("你对"..v.name.."发起\n了挑战你失败了", 24, {x = 130, y = (114 - 50)/2, color = ccc3(255, 0, 0)}))
				local lost_view = Btn:new(IMG_BTN, {"look.png", "look_press.png"}, 380, (114 - 4)/2, {
					callback = function()
						if tonumber(self.time_data.time) == 0 and tonumber(v.num) > 0 then
							HTTPS:send("Sports" ,{m="sports",a="sports",sports= "check",s_id=v.sid} ,{success_callback = 
								function()
									if scheduler then
										scheduler:unscheduleScriptEntry(time_back)
									end
									switchScene("fighting","sport")
							end })
						else
							Dialog.tip("冷却时间未到，请清除冷却时间")
						end
						
					end
				})
				
				layers[ temp_line ]:addChild(lost_view:getLayer())
				
				local revenge = Btn:new(IMG_BTN, {"revenge.png", "revenge_press.png"}, 380, (114 - 104)/2, {
					callback = function()
						self.layer:addChild(ShowDialog:create("您对"..v.name.."发起了复仇，剩余复仇次数为"..tonumber(v.num).."，是否进行挑战！",{
							success_callback = function()
								if tonumber(self.time_data.time) == 0 and tonumber(v.num) > 0 then
										HTTPS:send("Fighting",
										{a = "fighting",
										 m = "fighting", 
										 fighting = "start", 
										 type = "sports",
										 s_id = v.sid,
										 mode = 2
										 },{success_callback= function()
											switchScene("fighting","sport")
										 end
										 })
								elseif tonumber(v.num) <= 0  then
									Dialog.tip("您的复仇次数0，今天无法继续复仇。")
								else
									Dialog.tip("冷却时间未到，请清除冷却时间")
								end
							end
						}):getLayer())
					end
				})
				layers[ temp_line ]:addChild(revenge:getLayer())
			end
			
			temp_line = temp_line + 1
		end
		
		for i = 1 , #layers do
			sv:addChild( layers[i] )
		end
		other_layer = display.newLayer()
		other_layer:setContentSize( CCSizeMake(480 , 234) )
		other_layer:addChild(newLabel("我的声望:"..DATA_User:get("prestige"), 24, {x = 50, y = 190, color = ccc3(0, 0, 0)}))
		other_layer:addChild(newLabel("我的排名:"..self.time_data.top, 24, {x = 250, y = 190, color = ccc3(0, 0, 0)}))
		if tonumber(self.time_data.istime) == 0 then
			time_label = newLabel("冷却时间:0", 24, {x = 50, y = 140, color = ccc3(0, 0, 0)})
			other_layer:addChild(time_label)
		else
			time_label = newLabel("冷却时间:"..math.floor(tonumber(self.time_data.time)/60)..":"..(tonumber(self.time_data.time)%60), 24, {x = 50, y = 140, color = ccc3(0, 0, 0)})
			other_layer:addChild(time_label)
			clear = Btn:new(IMG_BTN, {"clear.png" ,"clear_press.png"}, 260, 130, {
				callback = function()
					local mins = math.floor(tonumber(self.time_data.time)/60)
					local num = 0
					if mins % 3 ~= 0 then
						num = math.floor(mins/3) + 1
					else
						num = math.floor(mins/2)
					end
					self.layer:addChild(ShowDialog:create("您是否花"..num.."代币清除冷却时间!",{
						success_callback = function()
							HTTPS:send("Sports" ,{m="sports",a="sports",sports= "clean"} ,{success_callback = 
								function()
									if scheduler then
										scheduler:unscheduleScriptEntry(time_back)
									end
									self:createRecord()	
									--local scene = display.getRunningScene()
									--scene:addChild(InfoLayer:create(false):getLayer())
							end })
						end
					}):getLayer())
					
					
				end
			})
			other_layer:addChild(clear:getLayer())
		end
		
		other_layer:addChild(newLabel("今日剩余挑战次数:"..self.time_data.challenge_num, 24, {x = 50, y = 90, color = ccc3(0, 0, 0)}))
		
		local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, 20, {
			callback = function()
				HTTPS:send("Exploreshop" ,{m="exlploreshop",a="exlploreshop",exlploreshop= "open"} ,{success_callback = 
						function()
							if scheduler then
								scheduler:unscheduleScriptEntry(time_back)
							end
							switchScene("prestigeShop")
				end })
			end
		})
		other_layer:addChild(shop:getLayer())
		
		local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, 20, {
			callback = function()
				HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=0} ,{success_callback = 
						function()
							if scheduler then
								scheduler:unscheduleScriptEntry(time_back)
							end
							switchScene("randsSport",{page=0,type="sport"})
				end })
			end
		})
		other_layer:addChild(rank:getLayer())
		
		sv:addChild(other_layer)
		self.listlayer:addChild(sv:getLayer())	
	else
		self.listlayer:addChild(newLabel("我的声望:"..DATA_User:get("prestige"), 24, {x = 50, y = 260, color = ccc3(0, 0, 0)}))
		self.listlayer:addChild(newLabel("我的排名:"..self.time_data.top, 24, {x = 250, y = 260, color = ccc3(0, 0, 0)}))
		if tonumber(self.time_data.istime) == 0 then
			time_label = newLabel("冷却时间:0", 24, {x = 50, y = 210, color = ccc3(0, 0, 0)})
			self.listlayer:addChild(time_label)
		else
			time_label = newLabel("冷却时间:"..math.floor(tonumber(self.time_data.time)/60)..":"..(tonumber(self.time_data.time)%60), 24, {x = 50, y = 210, color = ccc3(0, 0, 0)})
			self.listlayer:addChild(time_label)
			clear = Btn:new(IMG_BTN, {"clear.png" ,"clear_press.png"}, 260, 130, {
				callback = function()
					HTTPS:send("Sports" ,{m="sports",a="sports",sports= "clean"} ,{success_callback = 
							function()
								if scheduler then
									scheduler:unscheduleScriptEntry(time_back)
								end
								self:createRecord()	
								--local scene = display.getRunningScene()
								--scene:addChild(InfoLayer:create(false):getLayer())
							end })
				end
			})
			self.listlayer:addChild(clear:getLayer())
		end
		
		self.listlayer:addChild(newLabel("今日剩余挑战次数:"..self.time_data.challenge_num, 24, {x = 50, y = 160, color = ccc3(0, 0, 0)}))
		
		local shop = Btn:new(IMG_BTN, {"fame_shop.png" ,"fame_shop_press.png"}, 50, 90, {
			callback = function()
				HTTPS:send("Exploreshop" ,{m="exlploreshop",a="exlploreshop",exlploreshop= "open"} ,{success_callback = 
						function()
							if scheduler then
								scheduler:unscheduleScriptEntry(time_back)
							end
							switchScene("prestigeShop")
				end })
			end
		})
		self.listlayer:addChild(shop:getLayer())
		
		local rank = Btn:new(IMG_BTN, {"rank_list.png" ,"rank_list_press.png"} ,280, 90, {
			callback = function()
				HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=0} ,{success_callback = 
						function()
							if scheduler then
								scheduler:unscheduleScriptEntry(time_back)
							end
							switchScene("randsSport",{page=0,type="sport"})
				end })
			end
		})
		self.listlayer:addChild(rank:getLayer())
		
	end
	
	if tonumber(self.time_data.istime) ~= 0 then
		scheduler = CCDirector:sharedDirector():getScheduler()
		time_back = scheduler:scheduleScriptFunc(time_back_function, 1, false)
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
			if tonumber(v.num) > 0 then
				local other = Btn:new(PATH, {"bg_green.png", "bg_blue.png"}, 0, 0, {
					other = {{IMG_COMMON.."icon_bg"..v.icon_start..".png", 53, 90},{IMG_ICON.."hero/S_"..v.icon_id..".png", 53, 90}, {IMG_COMMON.."icon_border"..v.icon_start..".png", 53, 90}},
					text = {{"Lv "..v.lv, 20, ccc3(255,255,255), ccp(0, -45)}, {v.Name, 20, ccc3(255,255,255), ccp(0, -67)}},
					parent = scroll,
					callback = function()
						if self.time_data.challenge_num <= 0 then
							self.layer:addChild(ShowDialog:create("您对"..v.Name.."发起了挑战，剩余挑战次数为"..tonumber(v.num).."，是否进行挑战！今日挑战次数为0，需要使用10代币进行挑战！",{
									success_callback = function()
										if tonumber(self.time_data.time) == 0 and tonumber(v.num) > 0 then
										
												HTTPS:send("Fighting",
														{a = "fighting",
														 m = "fighting", 
														 fighting = "start", 
														 type = "sports",
														 s_id = v.Id, 
														 mode = 1
														 },{success_callback= function()
															switchScene("fighting","sport")
														 end
														 })
										elseif tonumber(v.num) <= 0 then
											Dialog.tip("您对"..v.Name.."的挑战次数为0，无法继续挑战")
										else
											Dialog.tip("冷却时间未到，请清除冷却时间")
										end
									end
								}):getLayer())
						else
							if v.num == 0 then
								self.layer:addChild(ShowDialog:create("您对"..v.Name.."发起了挑战，剩余挑战次数为"..tonumber(v.num)..",无法挑战，请刷新!",{
									success_callback = function()
										
									end
								}):getLayer())
							else
								self.layer:addChild(ShowDialog:create("您对"..v.Name.."发起了挑战，剩余挑战次数为"..tonumber(v.num).."，是否进行挑战！",{
									success_callback = function()
										if tonumber(self.time_data.time) == 0 and tonumber(v.num) > 0 then
										
												HTTPS:send("Fighting",
														{a = "fighting",
														 m = "fighting", 
														 fighting = "start", 
														 type = "sports",
														 s_id = v.Id, 
														 mode = 1
														 },{success_callback= function()
															switchScene("fighting","sport")
														 end
														 })
										elseif tonumber(v.num) <= 0 then
											Dialog.tip("您对"..v.Name.."的挑战次数为0，无法继续挑战")
										else
											Dialog.tip("冷却时间未到，请清除冷却时间")
										end
									end
								}):getLayer())
							end
						end
						
						
					end
				})
				scroll:addChild(other:getLayer())
			else
				local other = Btn:new(PATH, {"bg_blue.png"}, 0, 0, {
					other = {{IMG_COMMON.."icon_bg"..v.icon_start..".png", 53, 90},{IMG_ICON.."hero/S_"..v.icon_id..".png", 53, 90}, {IMG_COMMON.."icon_border"..v.icon_start..".png", 53, 90}},
					text = {{"Lv "..v.lv, 20, ccc3(255,255,255), ccp(0, -45)}, {v.Name, 20, ccc3(255,255,255), ccp(0, -67)}},
					parent = scroll,
					callback = function()
					
					end
				})
				scroll:addChild(other:getLayer())
			end
			
		end
	end
	
	
	
	self.layer:addChild(self.contentLayer)	
end

return AthleticsLayer