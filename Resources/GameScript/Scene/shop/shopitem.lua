local PATH = IMG_SCENE.."shop/"
local ShopItem = {
	layer,
	kind, --元素类型
	cid,
	params, -- 其它参数
	checkBox
}

function ShopItem:new(kind, key, params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = newLayer()
	this.kind = kind
	this.key = key 
	this.params = params or {}
	
	local bg = newSprite(PATH.."shop_item_bg.png")
	setAnchPos(bg)
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	
--	
	local icon = Btn:new(IMG_COMMON,{"icon_bg1.png"}, 20, 50, {
		front = IMG_ICON.."equip/S_7401.png",
		other = {IMG_COMMON.."icon_border1.png",45,45},
		scale = true,
		priority = this.params.priority,
		parent = this.params.parent,
		callback = this.params.iconCallback
	})
	this.layer:addChild(icon:getLayer())
	
	local buy = Btn:new(IMG_BTN, {"buy.png", "buy_pre.png"}, 370, 5, {
			priority = this.params.priority,
			parent = this.params.parent,
			callback = this.params.optCallback,
		})
	this.layer:addChild(buy:getLayer())
		
	
	this:createLayout(kind, key)
	
	return this
end

function ShopItem:getLayer()
	return self.layer
end

function ShopItem:getId()
	return self.cid
end

function ShopItem:choose(bool)
	self.checkBox:check(bool)
end

function ShopItem:isSelect()
	return self.checkBox:isSelect()
end

function ShopItem:createLayout(kind, key)
		local text = newLabel("名称:"..DATA_Shop:get(key, "name"),20,{x = 130, y = 115, color = ccc3(255,255,255)})
		self.layer:addChild(text)
		
		text = newLabel("价格:"..DATA_Shop:get(key, "money"),20,{x = 130, y = 75, color = ccc3(255,255,255)})
		self.layer:addChild(text)
		
		text = Label:new(DATA_Shop:get(key,"exps"),20, 240, 5)
		setAnchPos(text, 130,10)
		self.layer:addChild(text)
		
		
		
end

return ShopItem