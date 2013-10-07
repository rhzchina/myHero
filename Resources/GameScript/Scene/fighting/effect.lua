local PATH = IMG_SCENE.."fighting/"
local SINGLE, FAR, ALL, FULL = 1, 2, 3, 4   --特效类型，单体，远程， 全阵营， 全屏幕
local timeChange = 1  --特效时间的控制
local info = {
          --num, {ox, oy, fx, fy}, type
	[1001] = {5, {{-30, 90, true}, {30, -90, false, true}}, SINGLE, 0.05 },
	[1002] = {6, {{0, 0,}, {0, -30,}}, SINGLE, 0.08 },
	[1003] = {1, {{0, 0}, {0, 0, false, true}}, FAR, 0.1},
	[1004] = {1, {{0, 0}, {0, 0, false, true}}, FAR, 0.1},
	[1005] = {14, {{0, 0},{0, 0}}, FULL, 0.1},
	[2001] = {6, {{0, 0}, {0, 0}}, SINGLE, 0.08},
	[2002] = {8, {{0, 0}, {0, 0}}, SINGLE, 0.1},
	[2003] = {6, {{140, 0}, {140, 0}}, SINGLE, 0.1},
	[2004] = {10, {{0, 0}, {0, 0}}, ALL, 0.1},
	[2005] = {9, {{0, 0}, {0, 0}}, ALL, 0.1},
	[2006] = {8, {{0, 0}, {0, 0}}, ALL, 0.1},
	[2007] = {8, {{0, 0}, {0, 0}}, SINGLE, 0.1},
	[2008] = {7, {{0, 0}, {0, 0}}, SINGLE, 0.1},
	["explode"] = {6, {{0,0}, {0,0}}, SINGLE, 0.1},
}

local Effect = {
	layer,
	cache = CCSpriteFrameCache:sharedSpriteFrameCache(),
	added,
	name
}

function Effect:new()
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	this.added = {}  --保存当前已经添加的特效文 件
	return this 
end

function Effect:getLayer()
	return self.layer
end

	
function Effect:showByType(type,x,y,params)
	local params = params or {}
	local frames = CCArray:create()
	--test code	
	if type == 0 then
		type = "explode" 
	end
   --add effect 
	if not self.added[type] then
		print(type.."add complete")
		self.added[type] = true
		self.cache:addSpriteFramesWithFile(IMG_EFFECT..type..".plist",IMG_EFFECT..type..".png")
	end
	
	for i = 1, info[type][1] do
		frames:addObject(self.cache:spriteFrameByName(type.."_"..i..".png"))
	end
	
	--创建精灵来播放动画
	local sprite = newSprite()
	
	if info[type][3] == ALL then
		setAnchPos(sprite, 240, y > 425  and 637 or 210, 0.5, 0.5)
	elseif info[type][3] == FULL then
		setAnchPos(sprite, 240, 425, 0.5, 0.5)
		if params.name then
			self.name = createLabel({str = params.name, color = ccc3(0, 0, 0), size = 65, x = 210, y = 350, width = 400})
			self.layer:addChild(self.name, 1)
		end
	else
		setAnchPos(sprite, x + info[type][2][params.group][1], y + info[type][2][params.group][2], 0.5, 0.5)
	
		sprite:setFlipX(info[type][2][params.group][3])
		sprite:setFlipY(info[type][2][params.group][4])
	end
	
	--创建动画及动画完成后的回调 
	local animation = CCAnimation:createWithSpriteFrames(frames, info[type][4] / timeChange)
	local animate = CCAnimate:create(animation)
	frames:removeAllObjects()
	
	if info[type][3] == FAR then
		local time = math.sqrt(math.pow(params.target[1].x + params.width / 2 - x,2) + math.pow(params.target[1].y + params.height / 2 - y,2)) / 800 / timeChange
		local rotate = math.deg(math.atan((params.target[1].y  - y) / (params.target[1].x - x)))
		if x == params.target[1].x + params.width / 2 then  
			rotate = 0 
		end
		sprite:setRotation(rotate)
		
		frames:addObject(CCMoveTo:create(time, ccp(params.target[1].x + params.width / 2, params.target[1].y + params.height / 2)))
	else
		frames:addObject(animate)
	end
	frames:addObject(CCCallFunc:create(
		function() 
			self.layer:removeChild(sprite,true)				
			self.layer:removeChild(self.name, true)
			if params and params["callback"] then
				params.callback()
			end
--			local winner = DATA_Fighting:nextStep()
--			if not winner then
--				controller:fightLogic()
--			else
--				print("战斗结束",winner)
--				MsgBox.getInstance():flashShow("赢的人是",winner)
--			end
		end))
	
	if info[type][3] == FAR then
		sprite:runAction(CCRepeatForever:create(animate))
	end
	sprite:runAction(CCSequence:create(frames))
	
	
	
	self.layer:addChild(sprite)	
end

--function Effect:hpChange(kind,flag,num,x,y)
--		local value =flag..num
--		local text = newLabel(value,50)	
--		text:setColor(ccc3(55,255,0))
--		setAnchPos(text,x,y + 80)	
--		local array = CCArray:create()
--		array:addObject(CCMoveTo:create(0.8,ccp(x, y + 120)))
--		array:addObject(CCCallFunc:create(
--				function()
--					self.layer:removeChild(text,true)	
--				end))
--		text:runAction(CCSequence:create(array))
--		self.layer:addChild(text)
--end

function Effect:hpChange(kind,flag,num,x,y)
		local text = newAtlas(flag..num, PATH..kind.."_num.png", 45, 46,{x = x + 50, y = y + 50, ax = 0.5, ay = 0.5} )
		local effect = getSequence(
--			CCMoveTo:create(0.8,ccp(x, y + 120)),
			getSpawn(	
				CCJumpTo:create(0.6, ccp(x + 50, y +50), 100, 1),
				getSequence(
					CCScaleTo:create(0.1,0.8),
					CCEaseElasticOut:create(CCScaleTo:create(0.5,1))
				)
			),
			CCCallFunc:create(
				function()
					self.layer:removeChild(text,true)	
				end))
		text:runAction(effect)
		self.layer:addChild(text)
end

function Effect:clearCache()
	self.cache:removeSpriteFrames()
end

return Effect