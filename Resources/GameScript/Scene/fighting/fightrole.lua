local PATH = IMG_SCENE.."fighting/"
local KNBar = require(SRC.."Common/KNBar")

local HEROSTART, MONSTERSTART, SPACE = ccp(43,200), ccp(43,530), 40

--上阵位置信息
local position = {
	{
		{ccp(175, 200)},
		{ccp(20, 200), ccp(320, 200)},
		{ccp(20, 200), ccp(175,20), ccp(320, 200)},
		{ccp(20, 120), ccp(175,240), ccp(320, 120), ccp(175, 20)},
		{ccp(20, 200), ccp(175, 240), ccp(320, 200), ccp(20, 20), ccp(320, 20)},
		{ccp(20, 210), ccp(175, 240), ccp(320, 210), ccp(20, 20), ccp(175, 40), ccp(320, 20)},
	},  --我方英雄
	{
		{ccp(175, 480)},
		{ccp(20, 480), ccp(320, 480)},
		{ccp(20, 480), ccp(175, 650), ccp(320, 480)},
		{ccp(20, 510), ccp(175, 450), ccp(320, 510), ccp(175, 650)},
		{ccp(20, 480), ccp(175, 450), ccp(320, 480), ccp(20, 680), ccp(320, 680)},	
		{ccp(20, 480), ccp(175, 450), ccp(320, 480), ccp(20, 680), ccp(175, 650), ccp(320, 680),}	
	}   --怪物
}

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

function FightRole:new(group,id,pos,total,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	this.params = params or {}
	
	--战斗卡片背景
	this.bg = display.newSprite(PATH.."test_bg.png")
	setAnchPos(this.bg)
	this.layer:setContentSize(this.bg:getContentSize())
	this.layer:addChild(this.bg)
	
	this.width = this.bg:getContentSize().width
	this.height = this.bg:getContentSize().height
	this.group = group
	this.id = id
	this.pos = pos

	this.x = position[group][total][pos].x
	this.y = position[group][total][pos].y
	setAnchPos(this.layer, this.x,this.y, 0.5, 0.5)
	
	--英雄图标
	this.icon = newSprite(IMG_ICON.."hero/M_"..id..".png")
	setAnchPos(this.icon,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(this.icon)
	
--	--边框
--	local border = display.newSprite(PATH.."fight_border"..(pos % 4 + 1)..".png")
--	setAnchPos(border,this.width / 2, this.height / 2, 0.5, 0.5)
--	this.layer:addChild(border)
	
--	this.hpText = newLabel(this.params["hp"].."/"..this.params["hp"],15)
--	this.hpText:setColor(ccc3(255,0,0))
--	setAnchPos(this.hpText,this.width / 2,0,0.5)
--	this.layer:addChild(this.hpText,15)

--	--添加血条
--	local bgLayer = CCLayer:create()
--	local bg = display.newSprite(PATH.."bg.png")
--	setAnchPos(bg)
--	bgLayer:setContentSize(bg:getContentSize())
--	bgLayer:addChild(bg)
--	
--	this.hpProgress = CCProgressTimer:create(display.newSprite(PATH.."fore.png"))
--	setAnchPos(this.hpProgress)
--	this.hpProgress:setType(kCCProgressTimerTypeBar)
--	this.hpProgress:setBarChangeRate(CCPointMake(1, 0)) --动画效果值(0或1)
--	this.hpProgress:setMidpoint(CCPointMake(0 , 1))--设置进度方向 (0-100)
--	this.hpProgress:setPercentage(0)	--设置默认进度值
--	this.hpProgress:runAction(CCProgressTo:create(0.5,100))
--	bgLayer:addChild(this.hpProgress)
--	this.layer:addChild(bgLayer,5)	
	
	--点击事件
--	this.layer:setTouchEnabled(true)
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
--	self.hpProgress:setPercentage(curHp / self.params["hp"] * 100)
end

function FightRole:getY()
	return self.y
end

--执行战斗动作 type攻击类型，role：是攻击者还是被攻击者,callback 回调， id,攻击效果的id
function FightRole:doAction(type,role,callback,id)
	local anchY,moveY =  0, 0 
	if type == "atk" or type == "skill" then   --普通攻击
		if role == "adt" then   --攻击者特效
--			id = 1005
			self:cardAct("adt",
				function() 
					if self.params["effect"] then
							self.params["effect"]:showByType(id ,self.x + self.width / 2,self.y + self.height / 2,
						{
							callback = 
							function()
								local endAct = self:act(id, nil, true)
								if endAct then
									self.layer:runAction(endAct)
								end
								if callback then
									callback()
								end
							end,
							group = self.group,
						})
					end
				 end, id)
		else --被攻击的人
			self:cardAct("beat",
				function()
					if self.params["effect"] then
						self.params["effect"]:showByType(id,self.x + self.width / 2,self.y + self.height / 2,{
							callback = callback,
							group = self.group
						})
					end
				end, id)
		end
	elseif type == "skill" then
		print("技能数据改")
		if role == "adt" then
				
		else
		end
	else
		print("其它的",type)
	end
end

--卡牌的攻击表现
function FightRole:cardAct(kind, callback, id)
	local action
	if kind == "adt" then
		action = getSequence(self:act(id, callback))
			
	else
		action = getSequence(self:act(id, callback))
	end
	self.layer:runAction(action)
end

function FightRole:act(id,callback, finish)
	local info = {
		[1001] = "rotate", 
		[1002] = "scale",
		[1005] = "full",
	}
	
	local prepare, time
	
	if finish then
		prepare = CCMoveTo:create(0.1,ccp(self.x,self.y))
	else
		prepare = CCMoveTo:create(0.1,ccp(self.x, self.y + (self.group == 1 and 30 or -30)))
	end
	
	if info[id] == "rotate" then
		time = 0.2
		if finish then
			return prepare
		else
			return prepare, CCCallFunc:create(callback),
				 CCRotateBy:create(time, -360)	
		end
	elseif info[id] == "scale" then
		if finish then
--			self.icon:setTexture(newSprite(IMG_ICON.."hero/M_"..self.id..".png"):getTexture())
			self.icon:setScale(1)			
			self.layer:runAction(getSequence(CCScaleTo:create(0.1, 0.8), CCScaleTo:create(0.1, 1)))
		else
--			self.icon:setTexture(newSprite(IMG_ICON.."hero/L_"..self.id..".png"):getTexture())
			self.icon:runAction(CCScaleTo:create(0.1,1.8))
--			self.icon:setScale(1.5)
			return CCDelayTime:create(0.1), CCCallFunc:create(callback)
		end
	elseif info[id] == "flip" then
		time = 0.08
		if finish then
			return prepare
		else
			return prepare, CCCallFunc:create(callback),
				CCScaleTo:create(time, 0, 1),
				CCScaleTo:create(time, 1, 1),
				CCScaleTo:create(time, 0, 1),
				CCScaleTo:create(time, 1, 1)
		end
	elseif info[id] == "full" then
		if finish then
			self.icon:setTexture(newSprite(IMG_ICON.."hero/M_"..self.id..".png"):getTexture())
			self.bg:setVisible(true)	
		else
			self.icon:setTexture(newSprite(IMG_ICON.."hero/L_"..self.id..".png"):getTexture())
			self.bg:setVisible(false)
			return CCMoveTo:create(1, ccp(10, 425)), CCCallFunc:create(callback)
		end
	else
		time = 0.04
		return CCCallFunc:create(callback),
			CCScaleTo:create(time, 1.2),
			CCScaleTo:create(time, 0.8), 
			CCScaleTo:create(time, 1)
	end
end

return FightRole