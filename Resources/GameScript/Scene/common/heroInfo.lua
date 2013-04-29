--------[[武将信息]]

local cardInfo = {layer}

function cardInfo:new(data,x,y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.layer = CCLayer:create()


return this
end

function cardInfo:getLayer()
	return self.layer
end

return cardInfo
