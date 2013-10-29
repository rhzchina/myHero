NoticeLayer= {
	layer,     --功能层
	topLayer,
}
function NoticeLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self
	
	--首页的元素拆分开
	this.layer = newLayer()
	local mask 
	local data = DATA_Chat:get("announcement")
	local bg = newSprite(IMG_COMMON.."announ.png")
	bg:setScale(1.1)
	local layer = newLayer()
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	--local desc = newLabel("公告", 40, {x = 120, y = 565, dimensions=CCSizeMake(200, 60),color = ccc3(71, 31, 0)})
	--layer:addChild(desc)
	
	local close_btn = Btn:new(IMG_BTN,{"close.png", "close_press.png"}, 390, 650, {
		priority = -131,
		callback = function()
			this.layer:removeChild(mask, true)
		end
	})
	layer:addChild(close_btn:getLayer())
	
	local sv = ScrollView:new(35,134,480,518,0,false)
	local temp_line = 1
	local layers = {}
	for k,v in pairs(data) do
		if layers[ temp_line ] == nil then
			layers[ temp_line ] = display.newLayer()
			layers[ temp_line ]:setContentSize( CCSizeMake(380 , 280) )
		end
		local tip_bg = newSprite(IMG_COMMON.."announ_box.png")
		setAnchPos(tip_bg,34,0)
		tip_bg:setScale(1.1)
		layers[ temp_line ]:addChild(tip_bg)
		--标题
		local title = newLabel(v.name, 24, {x = 40, y = 210,color = ccc3(0, 0, 0)})
		layers[ temp_line ]:addChild(title)
		
		local content = newLabel(v.content, 18, {noFont = true, width = 340, color = ccc3(0, 0, 0), align = 0})
	
		setAnchPos(content,40,210 - title:getContentSize().height - content:getContentSize().height)
		
		layers[ temp_line ]:addChild(content)
		
		if tonumber(v.type) == 2 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					this.layer:removeChild(mask, true)
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
					this.layer:removeChild(mask, true)
					switchScene("update")
				end
			})
			layers[ temp_line ]:addChild(send_btn:getLayer())
		elseif tonumber(v.type) == 4 then
			local send_btn = Btn:new(IMG_BTN,{"comnon_bnt.png", "comnon_bnt_press.png"}, 120, 20, {
				text = {"点击进入", 20, ccc3(205, 133, 63), ccp(0, 0)},
				priority = -131,
				callback = function()
					this.layer:removeChild(mask, true)
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
					this.layer:removeChild(mask, true)
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
					this.layer:removeChild(mask, true)
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
					this.layer:removeChild(mask, true)
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
	this.layer:addChild(mask)
	return this
end

function NoticeLayer:getLayer()
	return self.layer
end