local ITEM = require(SRC.."Scene/shop/shopitem")
local Detail = require(SRC.."Scene/common/CardDetail")

local M = {
	layer,
	listLayer,
	tabGroup
}

function M:create( ... )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	local bg = newSprite(IMG_COMMON.."main.png")
	setAnchPos(bg, 0, 80)
	this.layer:addChild(bg)
	
	this.tabGroup = RadioGroup:new()
	
	local tabs = {
		{"hot", 1},
		{"card", 2},
		{"prop", 3},
		{"charge", 4},
	}
	
	local x = 12
	for k, v in pairs(tabs) do
		local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 668, { 
			callback = function()
				this:createList(v[2])
			end
		},this.tabGroup)
		this.layer:addChild(btn:getLayer())		
		x = x + btn:getWidth() + 5 
	end
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,667)
	this.layer:addChild(separator)
	
	this.tabGroup:chooseByIndex(1,true)
	
	local gift = Btn:new(IMG_BTN, {"gift.png", "gift_pre.png"}, 385, 665, {
	
	})
	this.layer:addChild(gift:getLayer())

	this.layer:addChild(InfoLayer:create():getLayer())
	return this.layer
end

function M:createList(kind)
	if self.listLayer then
		self.layer:removeChild(self.listLayer,true)
	end
	self.listLayer = CCLayer:create()
	
	local scroll = ScrollView:new(0,90,480,575,5)
	local temp
	for k, v in pairs(DATA_Shop:getByFilter(kind)) do
		local item 
		item = ITEM:new(kind, k,{
			parent = scroll,	
--			iconCallback = function()
--				self.layer:addChild(Detail:new(kind,v["cid"]):getLayer(),1)
--			end
		})
		scroll:addChild(item:getLayer(),item)
	end
	scroll:alignCenter()
	
	self.listLayer:addChild(scroll:getLayer())
	self.layer:addChild(self.listLayer)
end

return M
