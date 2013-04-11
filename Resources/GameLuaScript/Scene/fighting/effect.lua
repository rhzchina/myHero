local Effect = {
	layer,
	cache = CCSpriteFrameCache:sharedSpriteFrameCache()
}

function Effect:new()
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = display.newLayer()
	return this 
end

function Effect:getLayer()
	return self.layer
end

	
function Effect:showByType(controller,type,x,y,delay)
	local frames = CCArray:create()
	if type == "slash" then
		self.cache:addSpriteFramesWithFile(COMMONPATH.."/effect/slash.plist",COMMONPATH.."/effect/slash.png")
		for i = 1, 7 do
			frames:addObject(self.cache:spriteFrameByName("slash"..i..".png"))
		end	
	else
	end
		
	--创建精灵来播放动画
	local sprite = CCSprite:create()
	setAnchPos(sprite,x,y)
	
	--创建动画及动画完成后的回调 
	local animation = CCAnimation:createWithSpriteFrames(frames,delay)
	local animate = CCAnimate:create(animation)
	frames:removeAllObjects()
	frames:addObject(animate)
	frames:addObject(CCCallFunc:create(
		function() 
			self.layer:removeChild(sprite,true)				
			local winner = DATA_Fighting:nextStep()
			if not winner then
				controller:fightLogic()
			else
				print("战斗结束",winner)
				KNMsg.getInstance():flashShow("赢的人是",winner)
			end
		end))
	sprite:runAction(CCSequence:create(frames))
	self.layer:addChild(sprite)	
end

function Effect:clearCache()
	self.cache:removeSpriteFrames()
end

return Effect