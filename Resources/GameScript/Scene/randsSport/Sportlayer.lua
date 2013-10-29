--[[

登录框

]]
local MAIN = 1
local PATH = IMG_SCENE.."rand/"
local info_layer = requires(SRC.."Scene/randsSport/InfoLayer")
local M = {
	baseLayer,
	layer,
	create_layer,
	type_id
}

function M:create( params )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	local select_index = 1
	this.baseLayer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg, 0, 0)
	this.baseLayer:addChild(bg)
	if params.type == "sport" then
		local title = newSprite(PATH.."title_bg.png")
		setAnchPos(title,0,650)
		this.baseLayer:addChild(title)
		
		local btn = Btn:new(IMG_BTN, {"rand_bnt.png", "rand_bnt_press.png"}, 390, 650,{callback = function() 
			HTTPS:send("Sports", {m = "sports", a = "sports", sports = "get"}, {success_callback = function(data)
						switchScene("athletics", data)
				   end})
		end})
		this.baseLayer:addChild(btn:getLayer())
	else
		this.type_id = 1001
		local tra_data = DATA_Transcript:get()
		this.tabGroup = RadioGroup:new()
		local tabs = {
			{"1001", 1},
			{"1002", 2},
		}
			local x = 12
			for k, v in pairs(tabs) do
				local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 650, { 
					callback = function()
						if select_index ~= k then
							select_index = k
							this.type_id = v[1]
							HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "duplicate",type_id = v[1],page=0} ,{success_callback = 
								function()
									this:show(params)
							end })
						end
						
					end
				},this.tabGroup)
				this.baseLayer:addChild(btn:getLayer())		
				x = x + btn:getWidth() + 5 
		end
		
		local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
		setAnchPos(separator,0,650)
		this.baseLayer:addChild(separator)
		
		this.tabGroup:chooseByIndex(1,true)
	end
	
	this:show(params)
	
	return this
end

function M:show(params)
	if self.create_layer then
		self.baseLayer:removeChild(self.create_layer,true)
	end
	self.create_layer = CCLayer:create()
	
	local data 
	if params.type == "sport" then
		data = DATA_Rands:get_prestige()
	else
		data = DATA_Rands:get_prestige()
	end
	local scroll = ScrollView:new(0,95,480,554,10)
		
		for k,v in pairs(data) do
			local temp = {}
			temp.page = params.page
			temp.type = params.type
			temp.num = k
			if params.type == "sport" then
				temp.icon_id = v["icon_id"]
				temp.name = v["Name"]
				temp.lv = v["lv"]
				temp.prestige = v["prestige"]
			else
				temp.name = v["name"]
				temp.layer = v["layer"]
			end
			local block = info_layer:new(temp)
			scroll:addChild(block:getLayer(),block)
		end
		
		local end_layer = newLayer()
		end_layer:setContentSize( CCSizeMake(480 , 100) )
		
		local left = Btn:new(PATH, {"next_big.png"}, 190, 20, { 
					scale = true,
					flipX = true, 
					callback = function()
						if params.page > 0 then
							if params.type == "sport" then
								HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=(params.page - 1)} ,{success_callback = 
									function()
											self:show({page=(params.page - 1),type=params.type})
								end })
							else
								HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "duplicate",type_id = self.type_id,page=(params.page - 1)} ,{success_callback = 
									function()
										self:show({page=(params.page - 1),type=params.type})
								end })
							end
							
							
						else
							Dialog.tip("您现在已经在最前页")
						end
					end
				})
		end_layer:addChild(left:getLayer())
		
		local right = Btn:new(PATH, {"next_big.png"}, 250, 20, { 
					scale = true,
					callback = function()
						if params.page < 3  and (#data) == 10 then
							if params.type == "sport" then
								HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "prestige",page=(params.page + 1)} ,{success_callback = 
									function()
											self:show({page=(params.page + 1),type=params.type})
								end })
							else
								HTTPS:send("Ranking" ,{m="ranking",a="ranking",ranking = "duplicate",type_id = self.type_id,page=(params.page + 1)} ,{success_callback = 
									function()
										self:show({page=(params.page + 1),type=params.type})
								end })
							end
							
						else
							Dialog.tip("您现在已经在最后页")
						end
					end
				})
		end_layer:addChild(right:getLayer())
		
		local page_num = display.strokeLabel(params.page + 1,235,30,30,ccc3(0,0,0))
		end_layer:addChild(page_num)
		
		local my_rand = Btn:new(IMG_BTN, {"comnon_bnt.png"}, 320, 20, { 
					text = {"我排在第"..DATA_Rands:get_top().."名", 20, ccc3(205, 133, 63), ccp(0, 0)},
					callback = function()
						
					end
				})
		end_layer:addChild(my_rand:getLayer())
		
		scroll:addChild(end_layer,end_layer)
		scroll:alignCenter()
		scroll:setOffset(offset or 0)
		self.create_layer:addChild(scroll:getLayer())
		self.baseLayer:addChild(self.create_layer)
		
		
end

function M:getLayer()
	return self.baseLayer
end
return M
