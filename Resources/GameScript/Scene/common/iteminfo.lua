local ItemInfo = {
	layer,
	kind, --元素类型
	params -- 其它参数
}

function ItemInfo:new(kind,id,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	this.kind = kind
	this.params = params or {}
	
	local bg = newSprite(IMG_COMMON.."item_bg.png")
	setAnchPos(bg)
	this.layer:addChild(bg)
	this.layer:setContentSize(bg:getContentSize())
	
	local icon = newSprite(IMG_ICON..kind.."/S_"..id..".png")
	setAnchPos(icon,25,30)
	this.layer:addChild(icon)
	
	local text = newLabel("姓名:"..DATA_Bag:get(kind,id,"name"),20,{x = 130, y = 80, color = ccc3(0,0,0)})
	this.layer:addChild(text)
	
	text = newLabel("等级:"..DATA_Bag:get(kind,id,"lev"),20,{x = 130, y = 50, color = ccc3(0,0,0)})
	this.layer:addChild(text)
	
	return this
end

function ItemInfo:getLayer()
	return self.layer
end

return ItemInfo