local PATH = IMG_SCENE.."fighting/"
local KNBar = require("GameScript/Common/KNBar")

local HEROSTART, MONSTERSTART, SPACE = ccp(43,200), ccp(43,530), 40
local FightRole ={
	layer,
	x,
	y,
	width,
	height,
	group,
	id,
	pos,
--	hpText,
	hpProgress,
	params	
}

function FightRole:new(group,id,pos,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	this.params = params or {}
	--战斗卡片背景
	local bg = display.newSprite(PATH.."fight_back"..(pos % 4 + 1)..".png")
	setAnchPos(bg)
	this.layer:setContentSize(bg:getContentSize())
	this.layer:addChild(bg)
	
	this.width = bg:getContentSize().width
	this.height = bg:getContentSize().height
	this.group = group
	this.id = id
	this.pos = pos
	
	if group == 1 then --我方
		if pos > 2 then
			this.x = HEROSTART.x + (this.width + SPACE) * (pos - 3)			
			this.y = HEROSTART.y - this.height * 1.7 + SPACE
		else
			this.x = HEROSTART.x + (this.width + SPACE) * pos
			this.y = HEROSTART.y
		end
	else  --对方
		if pos > 2 then
			this.x = MONSTERSTART.x + (this.width + SPACE) * (pos - 3)			
			this.y = MONSTERSTART.y + this.height * 1.7 - SPACE	
		else
			this.x = MONSTERSTART.x + (this.width + SPACE) *  pos 
			this.y = MONSTERSTART.y
		end
	end
	setAnchPos(this.layer, this.x,this.y)
	
	--英雄图标
	local icon = display.newSprite(IMG_ICON.."hero/M_"..id..".png")
	setAnchPos(icon,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(icon)
	
	--边框
	local border = display.newSprite(PATH.."fight_border"..(pos % 4 + 1)..".png")
	setAnchPos(border,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(border)
	
--	this.hpText = newLabel(this.params["hp"].."/"..this.params["hp"],15)
--	this.hpText:setColor(ccc3(255,0,0))
--	setAnchPos(this.hpText,this.width / 2,0,0.5)
--	this.layer:addChild(this.hpText,15)

	--添加血条
	local bgLayer = CCLayer:create()
	local bg = display.newSprite(PATH.."bg.png")
	setAnchPos(bg)
	bgLayer:setContentSize(bg:getContentSize())
	bgLayer:addChild(bg)
	
	this.hpProgress = CCProgressTimer:create(display.newSprite(PATH.."fore.png"))
	setAnchPos(this.hpProgress)
	this.hpProgress:setType(kCCProgressTimerTypeBar)
	this.hpProgress:setBarChangeRate(CCPointMake(1, 0)) --动画效果值(0或1)
	this.hpProgress:setMidpoint(CCPointMake(0 , 1))--设置进度方向 (0-100)
	this.hpProgress:setPercentage(0)	--设置默认进度值
	this.hpProgress:runAction(CCProgressTo:create(0.5,100))
	bgLayer:addChild(this.hpProgress)
	this.layer:addChild(bgLayer,5)	
	
	--点击事件
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
		function(type,x,y) 
			if CCRectMake(this.x,this.y,this.width, this.height):containsPoint(ccp(x,y)) then
				if type == CCTOUCHBEGAN then
					this:doAction("atk","adt")
				else
				end
			else
			end
			return true
		end)
	
	return this
end

function FightRole:getLayer()
	return self.layer
end

function FightRole:getX()
	return self.x
end

function FightRole:setHp(curHp)
--	self.hpText:setString(curHp.."/"..self.params["hp"])
	self.hpProgress:setPercentage(curHp / self.params["hp"] * 100)
end

function FightRole:getY()
	return self.y
end

--执行战斗动作 type攻击类型，role：是攻击者还是被攻击者
function FightRole:doAction(type,role,callback)
	local array = CCArray:create()
	local flipX, flipY, anchX, anchY,moveY = false, false, 0, 0, 0 
	if type == "atk" then   --普通攻击
		if role == "adt" then   --攻击者特效
			if self.group == 1 then  --己方英雄
				self.layer:setAnchorPoint(ccp(1,0))
				flipX = true
				anchX = 0.5
				anchY = 0
				moveY = 30
			else
				self.layer:setAnchorPoint(ccp(0,1))
				flipY = true
				anchX = 0.2 
				anchY = 0.3
				moveY = -30
			end
			array:addObject(CCMoveTo:create(0.05,ccp(self.x,self.y + moveY)))
			array:addObject(CCRotateTo:create(0.1,5))  --攻击起手后仰
			array:addObject(CCCallFunc:create(    --起手完成后开始播放特效
				function() 
					if self.params["effect"] then
						self.params["effect"]:showByType("atk_cut",self.x,self.y,0.04,
						{
							callback = 
							function()
								self.layer:runAction(CCMoveTo:create(0.1,ccp(self.x,self.y)))
								self.layer:runAction(CCScaleTo:create(0.2,1))
								if callback then
									callback()
								end
							end,
							flipY = flipY,
							flipX = flipX,
							anchX = anchX,
							anchY = anchY 
						})
					end
				 end))
			array:addObject(CCRotateTo:create(0.05,-30))  --攻击旋转
			array:addObject(CCRotateTo:create(0.05,0))    --回位
			self.layer:runAction(CCSequence:create(array))
			self.layer:runAction(CCScaleTo:create(0.1,1.05))
		else
			self.layer:setAnchorPoint(ccp(0.5,0.5))
			array:addObject(CCCallFunc:create(
				function()
					if self.params["effect"] then
						self.params["effect"]:showByType("slash",self.x,self.y,0.05,{
							callback = callback,
							anchX = 0.3,
							anchY = 0.2
						})
					end
				end
			))
			array:addObject(CCScaleTo:create(0.1,0.8))			
			array:addObject(CCScaleTo:create(0.1,1))
			self.layer:runAction(CCSequence:create(array))
		end
	else
	end
end
return FightRole