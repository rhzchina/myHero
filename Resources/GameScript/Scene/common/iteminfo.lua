local ItemInfo = {
	layer,
	kind, --元素类型
	cid,
	params, -- 其它参数
	checkBox
}

function ItemInfo:new(kind,cid,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = newLayer()
	this.kind = kind
	this.cid = cid
	this.params = params or {}
	
	local bg, ix, iy 
	if this.params.type == "bag" then
		bg = newSprite(IMG_COMMON.."item_bg.png")
		ix = 30 
		iy = 15 
	else
		bg = newSprite(IMG_COMMON.."item_bg1.png")
		ix = 5 
		iy = 12
	end
	setAnchPos(bg)
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	

	local icon = Btn:new(IMG_COMMON,{"icon_bg"..(DATA_Bag:get(kind,cid,"star") or 1)..".png"}, ix, iy, {
		front = IMG_ICON..kind.."/S_"..DATA_Bag:get(kind,cid,"look")..".png",
		other = {IMG_COMMON.."icon_border"..(DATA_Bag:get(kind,cid,"star") or 1 )..".png",45,45},
		scale = this.params.iconCallback and true,
		priority = this.params.priority,
		parent = this.params.parent,
		callback = this.params.iconCallback
	})
	this.layer:addChild(icon:getLayer())
	
	if this.params.optCallback then
		local btn = Btn:new(IMG_BTN, {this.params["btn"]..".png", this.params["btn"].."_press.png"}, 340, 30, {
			callback = this.params.optCallback
		})
		this.layer:addChild(btn:getLayer())
	end

	this:createLayout(kind, cid)
	
	return this
end

function ItemInfo:getLayer()
	return self.layer
end

function ItemInfo:getId()
	return self.cid
end

function ItemInfo:getKind()
	return self.kind
end

function ItemInfo:choose(bool)
	self.checkBox:check(bool)
end

function ItemInfo:isSelect()
	return self.checkBox:isSelect()
end

function ItemInfo:createLayout(kind, cid)
	
	if self.params.type == "bag" then
		if kind ~= "prop" then
			local isOn  --是否已使用,或已上阵
			local state = "in_use.png"
			
			local text = newLabel("等级:"..DATA_Bag:get(kind,cid,"lev"),20,{x = 150, y = 50, color = ccc3(0,0,0)})
			self.layer:addChild(text)
			if kind == "hero" then
				isOn = DATA_Embattle:isOn(cid)
				state = "hero_on.png"
				
				text = newLabel(HeroConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 150, y = 75, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif kind == "equip" then
				isOn = DATA_Dress:isUse(cid)
				
				local id = DATA_Bag:get(kind,cid,"id")
				if tonumber(id) >= 6000 and tonumber(id) < 7000 then
					text = newLabel(ArmConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 150, y = 75, color = ccc3(0,0,0)})
					self.layer:addChild(text)
				elseif tonumber(id) >= 7000 and tonumber(id) < 8000 then
					text = newLabel(OrnamentConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 150, y = 75, color = ccc3(0,0,0)})
					self.layer:addChild(text)
				elseif tonumber(id) >= 5000 and tonumber(id) < 6000 then
					text = newLabel(ArmourConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 150, y = 75, color = ccc3(0,0,0)})
					self.layer:addChild(text)
				end
			elseif kind == "skill" then
				isOn = DATA_Dress:isUse(cid)
				
				local id = DATA_Bag:get(kind,cid,"id")
				text = newLabel(SkillConfig[id].name,20,{x = 150, y = 75, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			end
			
			local star
			for i = 1, DATA_Bag:get(kind,cid,"star") do
				star = newSprite(IMG_COMMON.."star.png")
				setAnchPos(star, 150 + (i - 1) * 25, 20)
				self.layer:addChild(star)
			end
			
			if isOn then
				local stateImg = newSprite(IMG_COMMON..state)
				setAnchPos(stateImg, 240, 30)
				self.layer:addChild(stateImg)
			end
		else
			local text = newLabel("名称:"..DATA_Bag:get(kind,cid,"name"),20,{x = 150, y = 80, color = ccc3(0,0,0)})
			self.layer:addChild(text)
			text = newLabel(DATA_Bag:get(kind, cid, "exps"), 20, {x = 140, y = 20, dimensions = CCSizeMake(180, 50)})
			self.layer:addChild(text)
		end
	else
		
		local text = newLabel("Lv "..DATA_Bag:get(kind,cid,"lev"),20,{x = 250, y = 70,noFont = true,  color = ccc3(0,0,0)})
		self.layer:addChild(text)
		if kind == "hero" then
			local text = newLabel(HeroConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
			self.layer:addChild(text)
		
			text = newLabel("血："..DATA_Bag:get(kind,cid,"hp").."  攻："..DATA_Bag:get(kind,cid,"att").."  防御："..DATA_Bag:get(kind,cid,"defe"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
			self.layer:addChild(text)
		elseif kind == "equip" then
			local id = DATA_Bag:get(kind,cid,"id")
			if tonumber(id) >= 6000 and tonumber(id) < 7000 then
				local text = newLabel(ArmConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
				
				text = newLabel("攻："..DATA_Bag:get(kind,cid,"att_i"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 7000 and tonumber(id) < 8000 then
				local text = newLabel(OrnamentConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
				
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp_i"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 5000 and tonumber(id) < 6000 then
				local text = newLabel(ArmourConfig[DATA_Bag:get(kind,cid,"id")].name,20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
				text = newLabel("防："..DATA_Bag:get(kind,cid,"def_i"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			end
		
		elseif kind == "skill" then
			local id = DATA_Bag:get(kind,cid,"id")
			local text = newLabel(SkillConfig[id].name,20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
			self.layer:addChild(text)
			if tonumber(id) >= 11000 and tonumber(id) < 12000 then
				text = newLabel("攻："..DATA_Bag:get(kind,cid,"att"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 12000 and tonumber(id) < 13000 then
				text = newLabel("攻："..DATA_Bag:get(kind,cid,"att"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 13000 and tonumber(id) < 14000 then
				text = newLabel("攻："..DATA_Bag:get(kind,cid,"att"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 14000 and tonumber(id) < 15000 then
				text = newLabel("攻："..DATA_Bag:get(kind,cid,"att"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 21000 and tonumber(id) < 22000 then
				text = newLabel("防："..DATA_Bag:get(kind,cid,"defe"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 22000 and tonumber(id) < 23000 then
				text = newLabel("防："..DATA_Bag:get(kind,cid,"chance").."%",20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 31000 and tonumber(id) < 32000 then
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 32000 and tonumber(id) < 33000 then
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 33000 and tonumber(id) < 34000 then
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 34000 and tonumber(id) < 35000 then
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			elseif tonumber(id) >= 35000 and tonumber(id) < 36000 then
				text = newLabel("血："..DATA_Bag:get(kind,cid,"hp"),20,{x = 130, y = 20, noFont = true, color = ccc3(0,0,0)})
				self.layer:addChild(text)
			end
		end
		
		self.checkBox = CheckBox:new(400, 60, {
			path = IMG_COMMON,
			file = {"box_bg.png", "box_choose.png"},
			checkBoxOpt = self.params.checkBoxOpt
		})
		self.layer:addChild(self.checkBox:getLayer())
	end
end

return ItemInfo