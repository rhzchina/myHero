UserInfoLayer= {
	layer,     --功能层
	topLayer,
	back_time
}
function UserInfoLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self
	local scheduler = nil
	local time_back = nil
	local time_label = nil
	local label_energy = nil
	local time_next = nil
	this.layer = newLayer()
	local mask 
	local bg = newSprite(IMG_COMMON.."userinfo.png")
	local layer = newLayer()
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	layer:addChild(bg)
	
	local info_bg = newSprite(IMG_COMMON.."info_bg.png")
	setAnchPos(info_bg, 240, 425, 0.5, 0.5)
	layer:addChild(info_bg)
	this.back_time = DATA_User:get("back_num")
	local other = tonumber(this.back_time)%60
	local mins = math.floor(tonumber(this.back_time)/60)--分钟
	if mins%2 == 0 and other == 0 then
		time_next = 120
	elseif mins%2 == 0 and other ~= 0 then
		time_next = other
	elseif mins%2 ~= 0 then
		time_next = 60 + other
	end
	
	
	--计算下一个体力恢复时间
	
	local function time_back_function()
			this.back_time = this.back_time  - 1
			if tonumber(this.back_time) <= -1 then
				this.back_time = 0	
				scheduler:unscheduleScriptEntry(time_back)
			end
			
			if tonumber(this.back_time) >= 0 then
				if time_label then
					time_label:setString("全部体力值恢复："..math.floor(tonumber(this.back_time)/60)..":"..(tonumber(this.back_time)%60))
				end
				if label_energy then
					label_energy:setString("体力值："..DATA_User:get("energy"))
				end
			end	
			
			if tonumber(this.back_time) >= 0 then
			
				time_next = time_next - 1
				
				if tonumber(time_next) <= -1 then
					--重新计算
					other = tonumber(this.back_time)%60
					mins = math.floor(tonumber(this.back_time)/60)--分钟
					if mins%2 == 0 and other == 0 and this.back_time > 0 then
						time_next = 120
					elseif mins%2 == 0 and other ~= 0 and this.back_time > 0 then
						time_next = other
					elseif mins%2 ~= 0 and this.back_time > 0 then
						time_next = 60 + other
					elseif this.back_time <= 0 then
						time_next = 0
					end
				end
				label_next:setString("下一个体力值恢复："..math.floor(tonumber(time_next)/60)..":"..(tonumber(time_next)%60))
			end
			
			
			
	end
	
	local close_btn = Btn:new(IMG_BTN,{"info_back.png", "info_back_press.png"}, 130, 90, {
		priority = -131,
		callback = function()
			this.layer:removeChild(mask, true)
			if scheduler then
				scheduler:unscheduleScriptEntry(time_back)
			end
			
		end
	})
	layer:addChild(close_btn:getLayer())
	
	local label_user_name = newLabel("用户名："..DATA_User:get("name"), 24, {x = 70, y = 635, ax = 0})
	layer:addChild(label_user_name)
	
	local label_user_name = newLabel("Lv："..DATA_User:get("lv"), 24, {x = 70, y = 600, ax = 0})
	layer:addChild(label_user_name)
	
	local label_user_name = newLabel("Exp："..DATA_User:get("Exp").."/"..DATA_User:get("Next_Exp"), 24, {x = 70, y = 565, ax = 0})
	layer:addChild(label_user_name)
	--local level = Progress:new(IMG_SCENE.."navigation/",{"info_exp_bg.png", "info_exp.png"}, 120, 557, {
	--	cur = math.floor(tonumber(DATA_User:get("Exp"))%tonumber(DATA_User:get("Next_Exp")))
	--})
	--layer:addChild(level:getLayer())
	
	local label_user_name = newLabel(""..DATA_User:get("Gold"), 24, {x = 70, y = 390, ax = 0})
	layer:addChild(label_user_name)
	
	local gold_leaf = newSprite(IMG_COMMON.."gold_leaf.png")
	setAnchPos(gold_leaf, 50, 398, 0.5, 0.5)
	layer:addChild(gold_leaf)
	
	local label_user_name = newLabel(""..DATA_User:get("Money"), 24, {x = 70, y = 355, ax = 0})
	layer:addChild(label_user_name)
	
	local silver = newSprite(IMG_COMMON.."silver.png")
	setAnchPos(silver, 50, 363, 0.5, 0.5)
	layer:addChild(silver)
	
	local label_user_name = newLabel(""..DATA_User:get("prestige"), 24, {x = 70, y = 320, ax = 0})
	layer:addChild(label_user_name)
	
	local shengwang = newSprite(IMG_COMMON.."shengwang.png")
	setAnchPos(shengwang, 50, 328, 0.5, 0.5)
	layer:addChild(shengwang)
	
	local label_user_name = newLabel("上阵武将："..DATA_Embattle:getnum(), 24, {x = 70, y = 425, ax = 0})
	layer:addChild(label_user_name)
	
	local label_user_name = newLabel("魂魄白："..DATA_User:get("soul_w"), 24, {x = 70, y = 530, ax = 0})
	layer:addChild(label_user_name)
	
	local label_user_name = newLabel("魂魄蓝："..DATA_User:get("soul_b"), 24, {x = 70, y = 495, ax = 0})
	layer:addChild(label_user_name)
	
	local label_user_name = newLabel("魂魄金："..DATA_User:get("soul_g"), 24, {x = 70, y = 460 , ax = 0})
	layer:addChild(label_user_name)
	
	local power = newSprite(IMG_COMMON.."power.png")
	setAnchPos(power, 50, 293, 0.5, 0.5)
	layer:addChild(power)
	
	label_energy = newLabel("体力值："..DATA_User:get("energy"), 24, {x = 70, y = 285, ax = 0})
	layer:addChild(label_energy)
	
	if tonumber(DATA_User:get("energy")) < 50 then
		
		label_next = newLabel("下一个体力值恢复："..math.floor(tonumber(time_next)/60)..":"..(tonumber(time_next)%60), 24, {x = 70, y = 250, ax = 0})
		layer:addChild(label_next)
		
		time_label = newLabel("全部体力值恢复："..math.floor(tonumber(this.back_time)/60)..":"..(tonumber(this.back_time)%60), 24, {x = 70, y = 215, ax = 0})
		layer:addChild(time_label)
		
		
		scheduler = CCDirector:sharedDirector():getScheduler()
		time_back = scheduler:scheduleScriptFunc(time_back_function, 1, false)
	else
		label_next = newLabel("下一个体力值恢复："..math.floor(tonumber(0)/60)..":"..(tonumber(0)%60), 24, {x = 70, y = 250, ax = 0})
		layer:addChild(label_next)
		
		time_label = newLabel("全部体力值恢复："..math.floor(tonumber(this.back_time)/60)..":"..(tonumber(this.back_time)%60), 24, {x = 70, y = 215, ax = 0})
		layer:addChild(time_label)
	end
	
	mask = Mask:new({item = layer})
	this.layer:addChild(mask)
	return this
end

function UserInfoLayer:getLayer()
	return self.layer
end