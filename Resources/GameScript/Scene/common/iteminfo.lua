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

function ItemInfo:choose(bool)
	self.checkBox:check(bool)
end

function ItemInfo:isSelect()
	return self.checkBox:isSelect()
end

function ItemInfo:createLayout(kind, cid)
	if self.params.type == "bag" then
		local text = newLabel("名称:"..DATA_Bag:get(kind,cid,"name"),20,{x = 150, y = 80, color = ccc3(0,0,0)})
		self.layer:addChild(text)
		
		if kind ~= "prop" then
			text = newLabel("等级:"..DATA_Bag:get(kind,cid,"lev"),20,{x = 150, y = 50, color = ccc3(0,0,0)})
			self.layer:addChild(text)
		
			local star
			for i = 1, DATA_Bag:get(kind,cid,"star") do
				star = newSprite(IMG_COMMON.."star.png")
				setAnchPos(star, 150 + (i - 1) * 25, 20)
				self.layer:addChild(star)
			end
		else
			text = newLabel(DATA_Bag:get(kind, cid, "exps"), 20, {x = 140, y = 20, dimensions = CCSizeMake(180, 50)})
			self.layer:addChild(text)
		end
	else
		local text = newLabel(DATA_Bag:get(kind,cid,"name"),20,{x = 130, y = 70,noFont = true, color = ccc3(0,0,0)})
		self.layer:addChild(text)
		
		text = newLabel("Lv "..DATA_Bag:get(kind,cid,"lev"),20,{x = 250, y = 70, noFont = true, color = ccc3(0,0,0)})
		self.layer:addChild(text)
		
		self.checkBox = CheckBox:new(400, 60, {
			path = IMG_COMMON,
			file = {"box_bg.png", "box_choose.png"},
			checkBoxOpt = self.params.checkBoxOpt
		})
		self.layer:addChild(self.checkBox:getLayer())
	end
end

return ItemInfo