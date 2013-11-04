local FightResult = {
	layer,
	contentLayer,
}

function FightResult:new(type_scene,result, hero, gift)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.contentLayer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."result_bg.png")
	setAnchPos(bg, 245, 420, 0.5, 0.5)
	this.contentLayer:addChild(bg)
	
	if result == 1 then
		bg = newSprite(IMG_COMMON.."lose.png")
	else
		bg = newSprite(IMG_COMMON.."win.png")
	end
	setAnchPos(bg, 245, 580, 0.5)
	this.contentLayer:addChild(bg)
	local temp = DATA_Fighting.haveData()
	print(type_scene)
	if type_scene == "task" then
		local gameover = temp["gameover"]["guanka"]["tast"]
		if gameover["Money"] then
			local silver = newSprite(IMG_COMMON.."silver_over.png")
			setAnchPos(silver,70,530)
			this.contentLayer:addChild(silver)
			
			local title_max = display.strokeLabel(gameover["Money"],230,533,30,ccc3(255,255,255))
			this.contentLayer:addChild(title_max)
		end
	
		if gameover["Exp"] then
			local silver = newSprite(IMG_COMMON.."exp_over.png")
			setAnchPos(silver,70,450)
			this.contentLayer:addChild(silver)
			
			local title_max = display.strokeLabel(gameover["Exp"],230,453,30,ccc3(255,255,255))
			this.contentLayer:addChild(title_max)
		end
		
		if temp["gameover"]["guanka"]["item"] then
		
			local silver = newSprite(IMG_COMMON.."font.png")
			setAnchPos(silver,170,300)
			this.contentLayer:addChild(silver)
			
			local scroll = ScrollView:new(40,130,480,200,10,true)
			local temp_btn
			for k,v in pairs(temp["gameover"]["guanka"]["item"]) do
				local str_icon
				local str_name
				if v.type == "hero" then
					str_icon = "hero/S_"..v.look
					str_name = getConfig("hero",v.id,"name")
				elseif v.type == "equip" then
					str_icon = "equip/S_"..v.look
					str_name = getConfig("equip",v.id,"name")
				end
				temp_btn = Btn:new(IMG_COMMON, {"icon_bg"..v.star..".png", "icon_bg"..v.star..".png"},  20 , 635,{
					other = {{IMG_ICON .. str_icon..".png",46,46},{IMG_COMMON .. "icon_border"..v.star..".png",46,46}},
					text = {str_name, 20, ccc3(255,255,255), ccp(0, -60), nil, 20},
					parent = scroll,
					callback = function()  
						
					end}
				)
				scroll:addChild(temp_btn:getLayer())
			end
			scroll:alignCenter()
			this.contentLayer:addChild(scroll:getLayer())
			
			if Lead:getStep() == 4 then
				Lead:show(nil, {
					x = temp_btn:getRange():getMinX(),
					y = temp_btn:getRange():getMinY(),
					width = temp_btn:getRange():getMaxX() - temp_btn:getRange():getMinX(),
					height = temp_btn:getRange():getMaxY() - temp_btn:getRange():getMinY(),
					offsetY = 400,
					callback = function()
					end
				})
			end
		end
	elseif type_scene == "sport" then
	
		local silver = newSprite(IMG_COMMON.."silver_over.png")
		setAnchPos(silver,70,530)
		this.contentLayer:addChild(silver)
		
		local title_max = display.strokeLabel(0,230,533,30,ccc3(255,255,255))
		this.contentLayer:addChild(title_max)
		
		local silver = newSprite(IMG_COMMON.."exp_over.png")
		setAnchPos(silver,70,450)
		this.contentLayer:addChild(silver)
		
		local title_max = display.strokeLabel(0,230,453,30,ccc3(255,255,255))
		this.contentLayer:addChild(title_max)
			
		local gameover = temp["gameover"]["guanka"]["tast"]
		if gameover then
			local silver = newSprite(IMG_COMMON.."pre_over.png")
			setAnchPos(silver,70,373)
			this.contentLayer:addChild(silver)
			
			local title_max = display.strokeLabel(""..gameover["add_prestige"],230,373,30,ccc3(255,255,255))
			this.contentLayer:addChild(title_max)
			
			---local title_max = display.strokeLabel("今日剩余挑战次数:"..gameover["time"]["challenge_num"],70,373,30,ccc3(255,255,255))
			--this.contentLayer:addChild(title_max)
			
			--local title_max = display.strokeLabel("当前排名:"..gameover["time"]["top"],70,433,30,ccc3(255,255,255))
			--this.contentLayer:addChild(title_max)
		end
	elseif type_scene == "copy" then		
		local silver = newSprite(IMG_COMMON.."silver_over.png")
		setAnchPos(silver,70,530)
		this.contentLayer:addChild(silver)
		
		local title_max = display.strokeLabel(0,230,533,30,ccc3(255,255,255))
		this.contentLayer:addChild(title_max)
		
		local silver = newSprite(IMG_COMMON.."exp_over.png")
		setAnchPos(silver,70,450)
		this.contentLayer:addChild(silver)
		
		local title_max = display.strokeLabel(0,230,453,30,ccc3(255,255,255))
		this.contentLayer:addChild(title_max)
		
		local gameover = temp["gameover"]["guanka"]["tast"]
		if gameover then
			--[[if tonumber(gameover["cur_id"]) == 1001 then
				local title_max = display.strokeLabel("星辰塔",130,533,30,ccc3(255,255,255))
				this.contentLayer:addChild(title_max)
			else
				local title_max = display.strokeLabel("隋宝塔",130,533,30,ccc3(255,255,255))
				this.contentLayer:addChild(title_max)
			end
			local title_max = display.strokeLabel("当前层："..gameover["cur_layer"],130,473,30,ccc3(255,255,255))
			this.contentLayer:addChild(title_max)
			]]
		end
--		if temp["gameover"]["guanka"]["item"] then
--			local silver = newSprite(IMG_COMMON.."font.png")
--			setAnchPos(silver,170,300)
--			this.contentLayer:addChild(silver)
--			
--			local scroll = ScrollView:new(40,130,480,200,10,true)
--			local temp_btn
--			for k,v in pairs(temp["gameover"]["guanka"]["item"]) do
--				local str_icon
--				local str_name
--				if v.type == "hero" then
--					str_icon = "hero/S_"..v.look
--					str_name = getConfig("hero",v.id,"name")
--				elseif v.type == "equip" then
--					str_icon = "equip/S_"..v.look
--					str_name = getConfig("equip",v.id,"name")
--				end
--				temp_btn = Btn:new(IMG_COMMON, {"icon_bg"..v.star..".png", "icon_bg"..v.star..".png"},  20 , 635,{
--					other = {{IMG_ICON .. str_icon..".png",46,46},{IMG_COMMON .. "icon_border"..v.star..".png",46,46}},
--					text = {str_name, 20, ccc3(255,255,255), ccp(0, -60), nil, 20},
--					parent = scroll,
--					callback = function()  
--						
--					end}
--				)
--				scroll:addChild(temp_btn:getLayer())
--			end
--			scroll:alignCenter()
--			this.contentLayer:addChild(scroll:getLayer())
--		end
	end
	--[[local gold = newSprite(IMG_COMMON.."gold_leaf.png")
	setAnchPos(gold,100, 530)
	this.contentLayer:addChild(gold)
	
	local silver = newSprite(IMG_COMMON.."silver.png")
	setAnchPos(silver,230,530)
	this.contentLayer:addChild(silver)
	
	local result_sprite = newSprite(IMG_COMMON.."s.png")	
	setAnchPos(result_sprite,330,520)
	this.contentLayer:addChild(result_sprite)
	
	local x, y = 60, 400
	for i = 1, table.nums(hero) do
		local btn = Btn:new(IMG_COMMON, {"icon_bg"..hero[i]["star"]..".png"}, x, y, {
			front = IMG_ICON.."hero/S_"..hero[i]["look"]..".png",
			other = {IMG_COMMON.."icon_border"..hero[i]["star"]..".png", 45, 45}
		})	
		this.contentLayer:addChild(btn:getLayer())
		
		x = x + btn:getWidth() * 1.5
		if i % 3 == 0 then
			x = 50
			y = y - btn:getHeight() * 1.2
		end
	end
	
	this.contentLayer:setScale(0.1)
	this.contentLayer:runAction(CCEaseBounceInOut:create(CCScaleTo:create(0.4,1)))
	]]
	
	
	
	this.contentLayer:setTouchEnabled(true)
	this.contentLayer:registerScriptTouchHandler(function(type, x, y)
		if type == CCTOUCHBEGAN then
			if type_scene == "task" then
				switchScene("roost")
			elseif type_scene == "sport" then
				switchScene("athletics")
			elseif type_scene == "copy" then
				if result == 1 then
					local task_data = gift["tast"]
					temp = {}
					temp.type_id = task_data.cur_id
					temp.cur_layer = task_data.cur_layer -1 
					switchScene("transcript",{type = 2,temp = temp})
				else
					local task_data = gift["tast"]
					temp = {}
					temp.type_id = task_data.cur_id
					temp.cur_layer = task_data.cur_layer
					switchScene("transcript",{type = 2,temp = temp})
				end
			end
		end
	end,false,-131,false)
	
	this.layer = Mask:new({item = this.contentLayer})
	return this
end

function FightResult:getLayer()
	return self.layer
end

return FightResult