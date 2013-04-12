local Effect = {
	layer,
	cache = CCSpriteFrameCache:sharedSpriteFrameCache(),
	added
}

function Effect:new()
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = display.newLayer()
	this.added = {}  --保存当前已经添加的特效文 件
	return this 
end

function Effect:getLayer()
	return self.layer
end

	
function Effect:showByType(type,x,y,delay,params)
	local frames = CCArray:create()
		if type == "slash" then
			if not self.added[type] then 
				print("slash添加")
				self.added[type] = true
				self.cache:addSpriteFramesWithFile(COMMONPATH.."effect/slash.plist",COMMONPATH.."effect/slash.png")
			end
			
			for i = 1, 7 do
				frames:addObject(self.cache:spriteFrameByName("slash"..i..".png"))
			end	
		elseif type == "atk_cut" then
			if not self.added[type] then 
				print("atk_cut添加")
				self.added[type] = true
				self.cache:addSpriteFramesWithFile(COMMONPATH.."effect/atk_cut.plist",COMMONPATH.."effect/atk_cut.png")
			end
			for i = 1, 7 do 
				frames:addObject(self.cache:spriteFrameByName("atk_cut"..i..".png"))
			end
		end
	--创建精灵来播放动画
	local sprite = CCSprite:create()
	local anchX, anchY = 0
	if params then
		if params.flipX then
			sprite:setFlipX(true)
		end
		
		if params.flipY then
			sprite:setFlipY(true)
		end
		
		if params.anchX then
			anchX = params.anchX
		end
		
		if params.anchY then
			anchY = params.anchY
		end
	end
	
	--创建动画及动画完成后的回调 
	local animation = CCAnimation:createWithSpriteFrames(frames,delay)
	local animate = CCAnimate:create(animation)
	frames:removeAllObjects()
	frames:addObject(animate)
	frames:addObject(CCCallFunc:create(
		function() 
			self.layer:removeChild(sprite,true)				
			if params and params["callback"] then
				params.callback()
			end
--			local winner = DATA_Fighting:nextStep()
--			if not winner then
--				controller:fightLogic()
--			else
--				print("战斗结束",winner)
--				KNMsg.getInstance():flashShow("赢的人是",winner)
--			end
		end))
	sprite:runAction(CCSequence:create(frames))
	setAnchPos(sprite,x,y,anchX,anchY)
	self.layer:addChild(sprite)	
end

function Effect:hpChange(num,x,y)
		local value ="-"..num
		local text = CCLabelTTF:create(value,"Aeria",50)	
		text:setColor(ccc3(55,255,0))
		setAnchPos(text,x,y + 80)	
		local array = CCArray:create()
		array:addObject(CCMoveTo:create(0.8,ccp(x, y + 120)))
		array:addObject(CCCallFunc:create(
				function()
					self.layer:removeChild(text,true)	
				end))
		text:runAction(CCSequence:create(array))
		self.layer:addChild(text)
	
end

function Effect:clearCache()
	self.cache:removeSpriteFrames()
end

return Effect