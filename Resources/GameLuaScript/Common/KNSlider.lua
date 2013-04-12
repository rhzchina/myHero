--按钮滑动条
KNSlider = {
    minimum = 0;
    maximum = 1;
    value = 0;
    onNewValue = function () end -- override
}
KNSlider._index=KNSlider

function KNSlider:new(path,x,y,minimum, maximum, initial, backFun)
	local this={}
	setmetatable(this,KNSlider)
	
	this.path=path or "perfection"
	this.x=x or 0
	this.y=y or 0
    this.minimum = minimum or 0;
    this.maximum = maximum or 1;
    --[[if initial==0 then center   
		if initial==maximum then right  
		if initial==minimum then left]]--
    this.value = initial or 0;
    this.onNewValue = backFun or function () end -- override
    
    local container = CCLayer:create()--创建对像容器
    container:ignoreAnchorPointForPosition(false)
    
    
    local imagePath = IMG_PATH .. "image/start_bar/"..this.path.."/"
    this.bg = display.newSprite(imagePath.."bg.png")
    container:addChild(this.bg, -2)
    
    this.progress  = display.newSprite(imagePath.."fore.png")
    container:addChild(this.progress, -1)
    
    this.thumb = display.newSprite(imagePath.."icon.png")
    container:addChild(this.thumb, 0)
    
    container:setContentSize(this.bg:getContentSize())--获取大小
    local s = container:getContentSize()
    
    this.bg:setAnchorPoint(ccp(0.5, 0.5));
    this.bg:setPosition(ccp(s.width/2, s.height/2))
    
    this.progress:setAnchorPoint(ccp(0.0, 0.5));
    this.progress:setPosition(ccp(0, s.height/2))
    
    this.thumb:setPosition(ccp(s.width/2, s.height/2))
    
    container:setAnchorPoint(ccp(0, 1));
    container:setPosition(ccp(display.width-(display.width-this.x),display.height-this.y))--设置坐标
    
    
    function container:onTouch(eventType, x, y)
        local where = CCPointMake(x,y)
        local nodeBB = container:boundingBox()
        local thumbBB = this.thumb:boundingBox()
        thumbBB.origin = ccpAdd(nodeBB.origin, thumbBB.origin)
        local isIn = thumbBB:containsPoint(where)
        if eventType == CCTOUCHBEGAN then return isIn
        elseif eventType == CCTOUCHMOVED then 
            container:setValue((this.maximum - this.minimum) * (x-nodeBB.origin.x)/nodeBB.size.width + this.minimum)
            return true
        elseif eventType == CCTOUCHENDED then return true
        end
	end
    
    

    container:setTouchEnabled( true );
    container:registerScriptTouchHandler(function (eventType, x, y) return container:onTouch(eventType, x, y) end)
    
    function container:layout(pt)
	    if this.minimum > this.maximum then this.minimum = this.maximum - 0.1 end -- sanity check
	    if this.value < this.minimum then this.value = this.minimum end
	    if this.value > this.maximum then this.value = this.maximum end
	    local percent = (this.value - this.minimum)/(this.maximum - this.minimum)
	    local pos = this.thumb:getPositionLua()
	    pos.x = percent * this.bg:getContentSize().width
	    this.thumb:setPosition(pos)
	    local textureRect = this.progress:getTextureRect();
	    textureRect =  CCRectMake(textureRect.origin.x, textureRect.origin.y, pos.x, textureRect.size.height)
	    this.progress:setTextureRect(textureRect, this.progress:isTextureRectRotated(), textureRect.size)
	    
	end
	
	function container:setMinimumValue(v) this.minimum = v end
	function container:setMaximumValue(v) this.maximum = v end
	function container:setValue(v)
	    this.value = v
	    container:layout()
	    this:onNewValue(this.value)
	end
   function container:getValue() return this.value end
   
    --初始进度
    container:setValue(this.value)
	return container 
end
return KNSlider

--local CCControlSlider = {
--    minimum = 0;
--    maximum = 1;
--    value = 0.5;
--    onNewValue = function () end -- override
--}
--
--function CCControlSlider:onTouch(eventType, x, y)
--        local where = CCPointMake(x,y)
--        local nodeBB = self.node:boundingBox()
--        local thumbBB = self.thumb:boundingBox()
--        thumbBB.origin = ccpAdd(nodeBB.origin, thumbBB.origin)
--        local isIn = thumbBB:containsPoint(where)
--        if eventType == CCTOUCHBEGAN then return isIn
--        elseif eventType == CCTOUCHMOVED then 
--            self:setValue((self.maximum - self.minimum) * (x-nodeBB.origin.x)/nodeBB.size.width + self.minimum)
--            return true
--        elseif eventType == CCTOUCHENDED then return true
--        end
--end
--
--function CCControlSlider:create(bgFile, progressFile, thumbFile)
--    local o = {}
--    o.bg = display.newSprite(bgFile)
--    o.progress  = display.newSprite(progressFile)
--    o.thumb = display.newSprite(thumbFile)
--    setmetatable(o, self)
--    self.__index = self
--    o.node = CCLayer:create()
--    o.node:ignoreAnchorPointForPosition(false)
--    o.node:setContentSize(o.bg:getContentSize())
--    o.node:addChild(o.bg, -2)
--    o.node:addChild(o.progress, -1)
--    o.node:addChild(o.thumb, 0)
--    local s = o.node:getContentSize()
--    o.bg:setAnchorPoint(ccp(0.5, 0.5));
--    o.bg:setPosition(ccp(s.width/2, s.height/2))
--    o.progress:setAnchorPoint(ccp(0.0, 0.5));
--    o.progress:setPosition(ccp(0, s.height/2))
--    o.thumb:setPosition(ccp(s.width/2, s.height/2))
--    o.node:setTouchEnabled( true );
--    o.node:registerScriptTouchHandler(function (eventType, x, y) return o:onTouch(eventType, x, y) end)
--    return o
--end
--
--function CCControlSlider:layout(pt)
--    if self.minimum > self.maximum then self.minimum = self.maximum - 0.1 end -- sanity check
--    if self.value < self.minimum then self.value = self.minimum end
--    if self.value > self.maximum then self.value = self.maximum end
--    local percent = (self.value - self.minimum)/(self.maximum - self.minimum)
--    local pos = self.thumb:getPositionLua()
--    pos.x = percent * self.bg:getContentSize().width
--    self.thumb:setPosition(pos)
--    local textureRect = self.progress:getTextureRect();
--    textureRect =  CCRectMake(textureRect.origin.x, textureRect.origin.y, pos.x, textureRect.size.height)
--    self.progress:setTextureRect(textureRect, self.progress:isTextureRectRotated(), textureRect.size)
--end
--
--function CCControlSlider:setPosition(pt) self.node:setPosition(pt) end
--function CCControlSlider:setMinimumValue(v) self.minimum = v end
--function CCControlSlider:setMaximumValue(v) self.maximum = v end
--function CCControlSlider:setValue(v)
--    self.value = v
--    self:layout()
--    self:onNewValue()
--end
--
--
--
--
--function sliderCtl(minimum, maximum, initial, onNewValue)
--	local imagePath=imagePath.."/start_bar/perfection/"
--    local slider = CCControlSlider:create(imagePath.."bg.png",imagePath.."fore.png",imagePath.."icon.png")
--    slider:setMinimumValue(minimum)
--    slider:setMaximumValue(maximum)
--    slider:setValue(initial)
--    slider.onNewValue = onNewValue
--    return slider;
--end