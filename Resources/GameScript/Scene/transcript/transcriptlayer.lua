
local TranscriptLayer = {
	layer
}

function TranscriptLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite("images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(IMG_TEXT.."card.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	
	
	
	return this
end


function TranscriptLayer:getLayer()
	return self.layer
end


return TranscriptLayer
