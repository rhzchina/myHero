local PATH = IMG_SCENE.."fighting/"
local KNBar = requires(SRC.."Common/KNBar")
local timeChange = 1
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
	params,
	lvLayer,
	temp
}

function FightRole:new(group,id,pos,total,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	
	this.params = params or {}
	dump(params)
	this.params.star = this.params.star > 5 and 5 or this.params.star
	--战斗卡片背景
--	this.bg = newSprite(PATH.."test_bg.png")
	this.bg = newSprite(PATH.."fight_back"..this.params.star..".png")
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
	
	this.hpProgress = CCProgressTimer:create(display.newSprite(PATH.."fore.png"))
	setAnchPos(this.hpProgress, this.width / 2 + 2, 13, 0.5)
	this.hpProgress:setType(kCCProgressTimerTypeBar)
	this.hpProgress:setBarChangeRate(CCPointMake(1, 0)) --动画效果值(0或1)
	this.hpProgress:setMidpoint(CCPointMake(0 , 1))--设置进度方向 (0-100)
	this.hpProgress:setPercentage(0)	--设置默认进度值
	this.hpProgress:runAction(CCProgressTo:create(0.5,100))
--	bgLayer:addChild(this.hpProgress)
--	this.layer:addChild(bgLayer,5)	
	this.layer:addChild(this.hpProgress)

	
	--英雄图标
	this.icon = newSprite(IMG_ICON.."hero/M_"..params.look..".png")
	setAnchPos(this.icon,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(this.icon)
	
	this.lvLayer = newLayer()	
	local levelBg = newSprite(PATH.."fight_border"..this.params.star..".png")
--	local levelBg = newSprite(PATH.."level_bg.png")
	
	this.lvLayer:setContentSize(levelBg:getContentSize())
	setAnchPos(this.lvLayer, 15, 5)
	this.lvLayer:addChild(levelBg)
	
	levelBg = newLabel(params.lv, 18,{color = ccc3(255, 0, 0) })
	setAnchPos(levelBg, 20, 15, 0.5)
	levelBg:setTag(102)
	this.lvLayer:addChild(levelBg)
	
	this.layer:addChild(this.lvLayer)
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
	self.hpProgress:setPercentage(curHp / self.params["hp"] * 100)
	if curHp <= 0 then
		transition.playSprites(self.layer, "tintTo", {
			r = 80,
			g = 80,
			b = 80,
			time = 0.3
		})
	end
end

function FightRole:getY()
	return self.y
end

--执行战斗动作 type攻击类型，role：是攻击者还是被攻击者,callback 回调， id,攻击效果的id, hpChange:掉血动画，sId：技能id
--function FightRole:doAction(type,role,callback,id, hpChange, sId)
function FightRole:doAction(type, role, params)
	params = params or {}
	if type == "atk" or type == "skill" then   --普通攻击
		local target = {}
		for i = 1, #params.target do
			--攻击目标列表，攻击方目标相反，被击者相同
			local des
			if role == "adt" then
				des = self.group == 1 and #DATA_Fighting:getMonster() or #DATA_Fighting:getHero()	
			else
				des = self.group == 1 and #DATA_Fighting:getHero() or #DATA_Fighting:getMonster()	
			end
			target[i] = position[params.target[i][1]][des][params.target[i][2]]
		end
		if role == "adt" then   --攻击者特效
			self:cardAct("adt",
				function() 
					if self.params["effect"] then
							self.params["effect"]:showByType(params.res_id ,self.x + self.width / 2,self.y + self.height / 2,
						{
							callback = 
							function()
								local endAct = self:act(params.res_id, nil, true)
								if endAct then
									self.layer:runAction(endAct)
								end
								if params.callback then
									params.callback()
								end
							end,
							name = params.skill_id and SkillConfig[params.skill_id..""].name or nil,
							group = self.group,
							target =  target,
							width = self.width,
							height = self.height
						})
					end
				 end, params.res_id)
		else --被攻击的人
			self:cardAct("beat",
				function()
					if self.params["effect"] then
						self.params["effect"]:showByType(params.res_id,self.x + self.width / 2,self.y + self.height / 2,{
							callback = params.callback,
							target =  target,
							group = self.group
						})
					end
				end, params.res_id, params.hpChange)
		end
	elseif type == "skill" then
		--print("技能数据改")
		if role == "adt" then
				
		else
		end
	else
		--print("其它的",type)
	end
end

--卡牌的攻击表现
function FightRole:cardAct(kind, callback, id, hpChange)
	local action
	--print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
	if kind == "adt" then
		action = getSequence(self:act(id, callback))
			
	else
		 action = getSequence(self:act(id, callback, nil,  hpChange))
	end
	--print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
	self.layer:runAction(action)
end

function FightRole:act(id,callback, finish, hpChange)
	local timeInfo = {
		["rotate"] = 0.2,
		["scale"] = 0.1,
		["flip"] = 0.08,
		["full"] = 500,   --全屏攻击的数值以移动的速度为单位
		["other"] = 0.04
		
	}
	
	local info = {
		[1001] = {"rotate"}, 
		[1002] = {"scale"},
		[1003] = {"flip"},
		[1004] = {"flip"},
		[1005] = {"full"},
		[2001] = {"other",0},
		[2002] = {"other",0.2},
		[2004] = {"other",0.55},
		[2005] = {"other",0.55},
		[2006] = {"other",0.4},
		[2007] = {"other",0.2},
		[2008] = {"other",0.5},
	}
	
	local prepare
	
	if finish then
		prepare = CCMoveTo:create(0.1,ccp(self.x,self.y))
	else
		prepare = CCMoveTo:create(0.1,ccp(self.x, self.y + (self.group == 1 and 30 or -30)))
	end
	
	local time = timeInfo[info[id] and info[id][1] or "other"] / timeChange
	
	local kind = info[id] and info[id][1] or "other"
	
	if kind == "rotate" then
		if finish then
			return prepare
		else
			return prepare, CCCallFunc:create(callback),
				 CCRotateBy:create(time, -360)	
		end
	elseif kind == "scale" then
		if finish then
--			self.icon:setTexture(newSprite(IMG_ICON.."hero/M_"..self.id..".png"):getTexture())
			self.icon:setScale(1)			
			self.lvLayer:setVisible(true)
			self.layer:runAction(getSequence(CCScaleTo:create(time, 0.8), CCScaleTo:create(time, 1)))
		else
--			self.icon:setTexture(newSprite(IMG_ICON.."hero/L_"..self.id..".png"):getTexture())
			self.lvLayer:setVisible(false)
			self.icon:runAction(CCScaleTo:create(time,1.8))
--			self.icon:setScale(1.5)
			return CCDelayTime:create(time), CCCallFunc:create(callback)
		end
	elseif kind == "flip" then
		if finish then
			return prepare
		else
			return prepare, CCCallFunc:create(callback),
				CCScaleTo:create(time, 0, 1),
				CCScaleTo:create(time, 1, 1),
				CCScaleTo:create(time, 0, 1),
				CCScaleTo:create(time, 1, 1)
		end
	elseif kind == "full" then
		time = math.sqrt(math.pow(425 - self.height / 2 - self.y, 2) + math.pow(10 - self.x, 2)) / time / timeChange
		
		
		if finish then
			self.params.base:removeChild(self.temp, true)
			self.params.parent:setVisible(true)
			return prepare
		else
--			self.icon:setTexture(newSprite(IMG_ICON.."hero/L_"..self.id..".png"):getTexture())
--			self.bg:setVisible(false)
			return prepare, getSpawn(CCCallFunc:create(function()
					self.temp = newSprite(IMG_ICON.."hero/L_"..self.params.look..".png")
					self.temp:setScaleX(self.width / self.temp:getContentSize().width)
					self.temp:setScaleY(self.height/ self.temp:getContentSize().height)
					setAnchPos(self.temp, self.x, self.y)
					self.params.base:addChild(self.temp)		
					self.params.parent:setVisible(false)
					self.temp:runAction(getSpawn(
						CCMoveTo:create(time, ccp(0, 400 - self.temp:getContentSize().height / 2)),
						CCScaleTo:create(time, 0.9, 0.9)))
				end)
				), CCDelayTime:create(time), CCCallFunc:create(callback)
		end
	else
		if info[id] and info[id][2] then
			return CCCallFunc:create(callback), CCDelayTime:create(info[id] and info[id][2] or 0),
				hpChange and CCCallFunc:create(hpChange) or nil,			
				CCScaleTo:create(time, 1.2),
				CCScaleTo:create(time, 0.8), 
				CCScaleTo:create(time, 1)
		else
			return CCCallFunc:create(callback), hpChange and CCCallFunc:create(hpChange) or nil
		end
	end
end

return FightRole