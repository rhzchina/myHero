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
	
	local icon = Btn:new(IMG_COMMON,{"icon_bg"..DATA_Bag:get(kind,id,"star")..".png"}, 25, 30, {
		front = IMG_ICON..kind.."/S_"..DATA_Bag:get(kind,id,"look")..".png",
		other = {IMG_COMMON.."icon_border"..DATA_Bag:get(kind,id,"star")..".png",45,45},
		scale = true,
		callback = this.params.iconCallback
	})
	this.layer:addChild(icon:getLayer())
	
	local text = newLabel("姓名:"..DATA_Bag:get(kind,id,"name"),20,{x = 150, y = 90, color = ccc3(0,0,0)})
	this.layer:addChild(text)
	
	text = newLabel("等级:"..DATA_Bag:get(kind,id,"lev"),20,{x = 150, y = 60, color = ccc3(0,0,0)})
	this.layer:addChild(text)
	
	for i = 1, DATA_Bag:get(kind,id,"star") do
		icon = newSprite(IMG_COMMON.."star.png")
		setAnchPos(icon, 150 + (i - 1) * 25, 30)
		this.layer:addChild(icon)
	end
	
	return this
end

function ItemInfo:getLayer()
	return self.layer
end

return ItemInfo