local Item = requires(SRC.."Scene/common/ItemInfo")
local ItemList = {
	layer,
	scroll,
	params,
	selectItem
}

function ItemList:new(params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.params = params or {}
	
	local itemLayer = newLayer()
	local bg = newSprite(IMG_COMMON.."list_bg.png")
	setAnchPos(bg)
	itemLayer:addChild(bg)
	
	this.scroll = ScrollView:new(0,160,480,555,5, false, 0, {
		priority = this.params.priority
	})
	local temp = DATA_Bag:getByFilter(this.params.type, this.params.filter)
	if this.params.type == "hero" then
		local temp_data = DATA_Embattle:get()
		for k,v in pairs(temp_data)do
			if _G.next(v) ~= nil then
				temp[v.cid..""] = nil
			end
		end
	elseif this.params.type == "equip" then
		local temp_data = DATA_Dress:get()
		for k,v in pairs(temp_data)do
			for k1,v1 in pairs(v)do
				if _G.next(v1) ~= nil then
					temp[v1.cid..""] = nil
				end
			end
		end
		for k,v in pairs(temp)do
			if this.params.pos == 2 then
				if tonumber(v.id) > 4999 and tonumber(v.id) < 5999 then

				else
					temp[v.cid..""] = nil	
				end
			elseif this.params.pos == 1 then
				if tonumber(v.id) > 5999 and tonumber(v.id) < 6999 then

				else
					temp[v.cid..""] = nil	
				end
			elseif this.params.pos == 3 then
				if tonumber(v.id) > 6999 and tonumber(v.id) < 7999 then

				else
					temp[v.cid..""] = nil	
				end
			end
		end
	elseif this.params.type == "skill" then
		local temp_data = DATA_Dress:get()
		for k,v in pairs(temp_data)do
			for k1,v1 in pairs(v)do
				if _G.next(v1) ~= nil then
					temp[v1.cid..""] = nil
				end
			end
		end
	end
	--除去部分元素
	--if this.params.except then
	--	for k, v in pairs(this.params.except) do
	--		temp[k..""] = nil			
	--	end
	--end
	
	for k, v in pairs(temp) do
		local item 
		item = Item:new(v["type"],v["cid"],{
			parent = this.scroll,	
			iconCallback = this.params.iconCallback,
			optCallback = this.params.optCallback,
			checkBoxOpt = function()
				--这里的复选框暂时默认是单选
				if item:isSelect() then	
					if this.selectItem then
						this.selectItem:choose(false)
					end
					this.selectItem = item
					this.selectItem:choose(true)
				else
					this.selectItem = nil
				end
				this.params.checkBoxOpt()
			end
		})
		this.scroll:addChild(item:getLayer(),item)
	end
	this.scroll:alignCenter()
	itemLayer:addChild(this.scroll:getLayer())
	
	local okBtn = Btn:new(IMG_BTN,{"ok.png", "ok_press.png"}, 50, 95, {
		priority = this.params.priority or -131,
		callback = function()
			if this.params.okCallback then
				this.params.okCallback()
			end
		end
	})
	itemLayer:addChild(okBtn:getLayer())
	
	local cancelBtn = Btn:new(IMG_BTN,{"cancel.png", "cancel_press.png"}, 290, 95, {
		priority = this.params.priority or -131,
		callback = function()
			if this.params.cancelCallback then
				this.params.cancelCallback()
			else
				this:remove()
			end
		end
	})
	itemLayer:addChild(cancelBtn:getLayer())
	
	local sortBtn = Btn:new(IMG_BTN,{"sort.png", "sort_press.png"}, 10, 735, {
		priority = this.params.priority or -131,
		callback = function()
		end
	})
	itemLayer:addChild(sortBtn:getLayer())
	
	local ruleBtn = Btn:new(IMG_BTN,{"all_star.png", "all_star_press.png"}, 380, 735, {
		priority = this.params.priority or -131,
		callback = function()
		end
	})
	itemLayer:addChild(ruleBtn:getLayer())
	
	
	this.layer = Mask:new({item = itemLayer})
	
	return this
end

function ItemList:getLayer()
	return self.layer
end

function ItemList:getSelectItem()
	return self.selectItem
end

function ItemList:getSelectId()
	return self.selectItem:getId()
end

function ItemList:remove()
	self.layer:removeFromParentAndCleanup(true)	
end

function ItemList:getSelectKind()
	return self.selectItem:getKind()
end

return ItemList