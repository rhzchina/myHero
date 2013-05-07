local PATH = IMG_SCENE.."detail/"
local CardDetail = {
	layer,
	contentLayer,
	kind, --元素类型
	params, -- 其它参数
	cancel
}

function CardDetail:new(kind,id,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.contentLayer = newLayer()
	
	this.kind = kind
	this.params = params or {}
	
	--大背景
	local bg = newSprite(PATH.."info_bg_small.png")
	setAnchPos(bg, 240, 425, 0.5, 0.5)
	this.contentLayer:addChild(bg)
	this.contentLayer:setContentSize(bg:getContentSize())
	
	--标题 
	local title = newSprite(PATH..kind.."_info_title.png")
	setAnchPos(title, 240, 425 + bg:getContentSize().height / 2, 0.5, 1.4)
	this.contentLayer:addChild(title)
	
	--卡片背景
	local cardBg = newSprite(PATH..kind.."_card_bg.png")
	setAnchPos(cardBg, 15, 290)
	this.contentLayer:addChild(cardBg)
	
	--介绍背景
	local intro = newSprite(PATH.."intro_bg.png")
	setAnchPos(intro,20 + cardBg:getContentSize().width ,290)
	this.contentLayer:addChild(intro)
	
	--图标
	local icon = newSprite(IMG_ICON..kind.."/L_"..DATA_Bag:get(kind,id,"look")..".png")
	setAnchPos(icon, 15 + cardBg:getContentSize().width / 2,290 + cardBg:getContentSize().height / 2, 0.5, 0.5)
	this.contentLayer:addChild(icon)
	
	--星级
	local y, star = 580
	for i = 1, DATA_Bag:get(kind, id, "star") do
		star = newSprite(IMG_COMMON.."star.png")
		setAnchPos(star, 235, y)
		this.contentLayer:addChild(star)
		y = y - star:getContentSize().height
	end
	
	--名字显示
	local nameBg = newSprite(PATH.."name_bg.png")
	setAnchPos(nameBg, 35, 515)
	this.contentLayer:addChild(nameBg)
	
	local nameText = DATA_Bag:get(kind,id,"name")
	local size = 60 / (string.len(nameText) / 3) + 1
	print(size)
	local name = newLabel(nameText, size, 
		{
			x = 35 + nameBg:getContentSize().width / 2, 
			y = 515 + nameBg:getContentSize().height / 2, 
			ax = 0.5, ay = 0.5, dimensions = CCSize:new(size,80)
		})
	this.contentLayer:addChild(name)
	
	local btn = Btn:new(IMG_BTN,{"btn_bg.png", "btn_bg_press.png"}, 130, 190, {
		front = IMG_TEXT.."strengthen.png",
		priority = -132,
		callback = function()
			this.cancel = false
		end
	})
	this.contentLayer:addChild(btn:getLayer())
	
	--
	this.contentLayer:setTouchEnabled(true)
	this.contentLayer:registerScriptTouchHandler(
	function(type, x, y)
		if type == CCTOUCHBEGAN then
			this.cancel = true
		elseif type == CCTOUCHMOVED then
		else
			if this.cancel then
				this.layer:removeFromParentAndCleanup(true)
			end
			this.cancel = true
		end				
		return true
	end,false,-131,false)
	
	this.layer = Mask:new({item = this.contentLayer})
	return this
end

function CardDetail:getLayer()
	return self.layer
end

return CardDetail