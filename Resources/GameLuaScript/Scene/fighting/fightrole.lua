local ICONPATH = "image/myhero/battle/"
local PATH = "image/scene/fighting/"

local HEROSTART, MONSTERSTART, SPACE = ccp(43,70), ccp(43,670), 40
local FightRole ={
	layer,
	x,
	y,
	width,
	height,
	group,
	id,
	pos,
	effect--测试用
	
}

function FightRole:new(group,id,pos,effect)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = display.newLayer()
	this.effect = effect
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
			this.y = HEROSTART.y + this.height + SPACE
		else
			this.x = HEROSTART.x + (this.width + SPACE) * pos
			this.y = HEROSTART.y
		end
	else  --对方
		if pos > 2 then
			this.x = MONSTERSTART.x + (this.width + SPACE) * (pos - 3)			
			this.y = MONSTERSTART.y - this.height - SPACE	
		else
			this.x = MONSTERSTART.x + (this.width + SPACE) *  pos 
			this.y = MONSTERSTART.y
		end
	end
	setAnchPos(this.layer, this.x,this.y)
	
	--英雄图标
	local icon = display.newSprite(ICONPATH..id..".png")
	setAnchPos(icon,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(icon)
	
	--边框
	local border = display.newSprite(PATH.."fight_border"..(pos % 4 + 1)..".png")
	setAnchPos(border,this.width / 2, this.height / 2, 0.5, 0.5)
	this.layer:addChild(border)
	
	--点击事件
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
		function(type,x,y) 
			if CCRectMake(this.x,this.y,this.width, this.height):containsPoint(ccp(x,y)) then
				if type == CCTOUCHBEGAN then
					this:doAction("atk")
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

function FightRole:doAction(type)
	if type == "atk" then
		local array = CCArray:create()
		if self.group == 1 then
			self.layer:setAnchorPoint(ccp(1,0))
		else
			self.layer:setAnchorPoint(ccp(1,1))
		end
		array:addObject(CCRotateTo:create(0.20,20))
		array:addObject(CCCallFunc:create(function() self.effect:showByType("slash",self.x,self.y,0.08) end))
		array:addObject(CCRotateTo:create(0.10,-40))
		array:addObject(CCRotateTo:create(0.05,0))
		self.layer:runAction(CCSequence:create(array))
	else
	end
end
return FightRole