local PATH = "bag/"
local ITEM = require(SRC.."Scene/common/iteminfo")
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
	
	local bg = newSprite(IMG_COMMON.."bg.png")
	setAnchPos(bg, 0, 80)
	this.layer:addChild(bg)
	
	this.tabGroup = RadioGroup:new()
	
	local tabs = {
		{"equip"},
		{"hero"},
		{"skill"},
		{"prop"}
	}
	
	local x = 12
	for k, v in pairs(tabs) do
		local btn = Btn:new(IMG_COMMON.."tabs/", {"tab_"..v[1]..".png", "tab_"..v[1].."_select.png"}, x, 628, { 
			callback = function()
				this:createList(v[1])
			end
		},this.tabGroup)
		this.layer:addChild(btn:getLayer())		
		x = x + btn:getWidth() + 5 
	end
	
	local separator = newSprite(IMG_COMMON.."tabs/tab_separator.png")
	setAnchPos(separator,0,627)
	this.layer:addChild(separator)

	this:createList("hero")
	return this.layer
end

function M:createList(kind)
	if self.listLayer then
		self.layer:removeChild(self.listLayer,true)
	end
	self.listLayer = CCLayer:create()
	
	local scroll = ScrollView:new(5,175,480,450,5)
	for k, v in pairs(DATA_Bag:get(kind)) do
		local item = ITEM:new(kind,v["id"])
		scroll:addChild(item:getLayer(),item)
	end
	scroll:alignCenter()
	
	self.listLayer:addChild(scroll:getLayer())
	self.layer:addChild(self.listLayer)
end

return M
