local LuaProgress = {
	layer,
	params,
	progress
}

function LuaProgress:new(dir, res, x, y, params)
	local this = {} 
	setmetatable(this,self)
	self.__index = self
	
	this.params = params or {}
	this.layer = newLayer()
	
	local res = res or {}
	
	local bg = newSprite(dir..res[1])
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	this.layer:setContentSize(bg:getContentSize())
	setAnchPos(this.layer, x, y)
	
	this.progress = CCProgressTimer:create(newSprite(dir..res[2]))
	setAnchPos(this.progress)
	
	--进度条的属性设置
	this.progress:setType(kCCProgressTimerTypeBar)           --类型，kCCProgressTimerTypeBar 横向，kCCProgressTimerRidial 圆
	this.progress:setMidpoint(ccp(0, 0))                     --进度方向
	this.progress:setBarChangeRate(ccp(1,0))                 --对应方向上是否进行设置
	this.progress:setPercentage(this.params.cur or 0)                           --进度0--100
	this.layer:addChild(this.progress)
	
	if this.params["leftIcon"] then
		local icon = newSprite(dir..this.params["leftIcon"][1])
		setAnchPos(icon,this.params["leftIcon"][2] , this.params["leftIcon"][3], 1, 0.5)
		this.layer:addChild(icon)
	end
	
	return this
end

function LuaProgress:setCur(percent, ani)
	if ani then
		self.progress:runAction(CCProgressTo:create(1,percent))
	else
		self.progress:setPercentage(percent)
	end
--	self.progress:runAction(CCProgressFromTo:create(1,0,percent))
end

function LuaProgress:getCur()
	self.progress:getPercentage()
end

function LuaProgress:getLayer()
	return self.layer
end



return  LuaProgress