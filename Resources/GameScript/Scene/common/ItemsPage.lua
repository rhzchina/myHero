local ItemPage = {
	layer,
	itemsLayer,
	mask,
	params,
	max,
	cur,
	selectItems,
	nums
}

function ItemPage:new(x, y, params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = newLayer()
	this.params = params or {}
	this.cur = 1
	this.max = 1
	this.selectItems = this.params.data or {} 
	
	local bg = newSprite(IMG_COMMON.."list_bg.png")
	setAnchPos(bg)
	this.layer:setContentSize(bg:getContentSize())
	this.layer:addChild(bg)
	
	setAnchPos(this.layer, x, y)
	
	
	bg = newSprite(IMG_COMMON.."page_bg.png")
	setAnchPos(bg, 0, 675 - y)
	this.layer:addChild(bg)
	
	this:createItems(150 - y)

	this:turnLayer(100 - y)
	
	local back = Btn:new(IMG_BTN, {"back.png", "back_press.png"}, 380, 740 - y, {
		priority = -131,
		callback = function()
			this.mask:removeFromParentAndCleanup(true)
		end
	})
	this.layer:addChild(back:getLayer())
	
	
	this.mask = Mask:new({item = this.layer})
	return this
end

function ItemPage:turnLayer(y)
	
	local realY = y
	if self.params.showOpt then
		realY = y + 70
		
		local opt = Btn:new(IMG_BTN, self.params.showOpt[1], 300, y, {
			priority = -131,
			callback = self.params.showOpt[2]
		} )
		setAnchPos(opt:getLayer(), 470 - opt:getWidth(), y)
		self.layer:addChild(opt:getLayer())
		
		self.nums = newLabel("已选择:"..table.nums(self.selectItems), 20)
		setAnchPos(self.nums, 0, y + 30)
		self.layer:addChild(self.nums)
	end
	
	local bg = newSprite(IMG_COMMON.."page_bg.png")
	setAnchPos(bg, 0, realY)
	self.layer:addChild(bg)
	
	local page = newLabel((self.cur or 1).."/"..(self.max or 1), 25, {x = 240, y = realY + 3, ax = 0.5})
	self.layer:addChild(page)
	
	local preBtn = Btn:new(IMG_BTN, {"pre_page.png", "pre_page_press.png"},80, realY + 2, {
		priority = -131,
		callback = function()
			if self.cur > 1 then
				self.itemsLayer:runAction(getSequence(CCMoveTo:create(0.2,ccp(480, 0)),CCCallFunc:create(function()
						self.cur = self.cur - 1
						self:createItems(y + 50, true, -1)
						page:setString(self.cur.."/"..self.max)
				end)))
			end
		end
	})
	self.layer:addChild(preBtn:getLayer())
	
	local nextBtn = Btn:new(IMG_BTN, {"next_page.png", "next_page_press.png"}, 300, realY + 2, {
		priority = -131,
		callback = function()
			
			if self.cur < self.max then					
				self.itemsLayer:runAction(getSequence(CCMoveTo:create(0.2,ccp(-480, 0)),CCCallFunc:create(function()
						self.cur = self.cur + 1
						self:createItems(y + 50, true, 1)
						page:setString(self.cur.."/"..self.max)
				end)))
			end
		end
	})
	self.layer:addChild(nextBtn:getLayer())
	
end

function ItemPage:createItems(by, ani, dir)
	if self.itemsLayer then
		self.layer:removeChild(self.itemsLayer, true)
	end
	
	if self.params.type then
		self.itemsLayer = newLayer()
		
		local list = getSortKey( getBag(self.params.type)) 
		local max,total, spaceY = 12,#list, 1.4 
		if self.params.showOpt then  --在翻页下方是不是有操作的按钮
			max = 9
			spaceY = 1.6
		end
		self.max = math.ceil(total / max)
		
		local num = max
		if total - max * (self.cur - 1) < max then
			num = total - max * (self.cur - 1)
		end
		
		
		local x, y, count = 30, by + 420, 1
		local start = (self.cur - 1) * num 
		for i = start + 1, start + num do
				local item 
				item = Btn:new(IMG_COMMON, {"icon_bg"..getBag(self.params.type, list[i], "star")..".png", "card_selected.png"}, x, y, {
				scale = true,
				priority = -131,
				selectable = true,
				selectZOrder = 20,
				selectOffset = {28, -30},
				noHide = true,
				front = IMG_ICON..self.params.type.."/".."S_"..getBag(self.params.type, list[i], "look")..".png",
				other = {IMG_COMMON.."icon_border"..getBag(self.params.type, list[i], "star")..".png", 45, 45},
				text = {getBag(self.params.type, list[i], "name"), 20, ccc3(255,255,255), ccp(0, -60)},
				callback = function()
					if item:isSelect() then
						self.selectItems[list[i]] = list[i]
						self.nums:setString("已选择:"..table.nums(self.selectItems))
					else
						self.selectItems[list[i]] = nil
						self.nums:setString("已选择:"..table.nums(self.selectItems))
					end
				end
			})
			self.itemsLayer:addChild(item:getLayer())
			if self.selectItems[list[i]] then
				item:select(true)
			end
			
			x = x + item:getWidth() * 1.8	
			if count % 3 == 0 then
				x = 30 
				y = y - item:getHeight() * spaceY 
			end
			
			count = count + 1
		end
		self.layer:addChild(self.itemsLayer)
		
		if ani then
			self.itemsLayer:setPositionX(480 * dir)
			self.itemsLayer:runAction(CCMoveTo:create(0.2,ccp(0,0)))
		end
	end
end

function ItemPage:getLayer()
	return self.mask
end

function ItemPage:getItems()
	return self.selectItems
end

return ItemPage