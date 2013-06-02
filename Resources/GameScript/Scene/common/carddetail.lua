local PATH = IMG_SCENE.."detail/"
local CardInfo = require(SRC.."Scene/common/CardInfo")
local CardDetail = {
	layer,
	contentLayer,
	kind, --元素类型
	params, -- 其它参数
	cancel
}

function CardDetail:new(kind,cid,params)
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
	
	local card = CardInfo:new(15, 290, {type = kind, cid = cid})
	this.contentLayer:addChild(card:getLayer())
	
	--介绍背景
	local intro = newSprite(PATH.."intro_bg.png")
	setAnchPos(intro,20 + card:getWidth() ,290)
	this.contentLayer:addChild(intro)
	
	intro = newLabel("简介", 20, {x = 350, y = 596, noFont = true, color = ccc3(0, 0, 0)})
	this.contentLayer:addChild(intro)
	
	intro = newLabel("困苦进顶替顶替栽顶替茜茜茜村茜枯堙苛塔顶地", 20, {x = 290, y = 250,dimensions = CCSizeMake(150, 200), noFont = true})
	this.contentLayer:addChild(intro)

	
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