local PATH = "image/scene/fighting/"
local KNBtn = require "GameLuaScript/Common/KNBtn"
local FightRole = require "GameLuaScript/Scene/fighting/fightrole"
local Effect = require "GameLuaScript/Scene/fighting/effect"
local FightLayer = {
	layer,
	group,
	roleLayer,     --对战双方卡片所在层
	effect   --特效层
	
}

function FightLayer:new()
local this = {}	
	setmetatable(this,self)
	self.__index = self
	DATA_Fighting:getAttackType()
	
	this.layer = display.newLayer()
	this.roleLayer = display.newLayer()
	this.effect = Effect:new()
	
	this.group = {
		{}, --我方上阵英雄
		{}  --敌方
	}
	--战斗场景背景
	local bg = display.newSprite(PATH.."fightingbg1.png")	
	setAnchPos(bg)	
	this.layer:addChild(bg)
	
	--跳 过按钮
	local exit = KNBtn:new(PATH,{"fighting_quit.png"},420,800,{
		scale = true,
		callback = 
		function()
		end})
	this.layer:addChild(exit:getLayer())
	
	--初始化英雄
	for i, v in pairs(DATA_Fighting:getHero()) do
		this.group[1][i - 1] = FightRole:new(1, v["card_id"], i - 1,this.effect) 
		this.roleLayer:addChild(this.group[1][i - 1]:getLayer())
	end
	
	--初始化怪兽
	for i,v in pairs(DATA_Fighting:getMonster()) do
		this.group[2][i - 1] = FightRole:new(2, v["card_id"], i - 1,this.effect) 
		this.roleLayer:addChild(this.group[2][i - 1]:getLayer())
	end
--	print("战斗开始")
--		DATA_Fighting:getAttackType()
--		process = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(
--		function()
--			print(process,"------------------回合"..DATA_Fighting:getTurn().."-------------")
--			print("第"..DATA_Fighting:getStep().."步")
--			print("   攻击方"..DATA_Fighting:getAttacker("group"))
--			print("   位置"..DATA_Fighting:getAttacker("index"))
--			print("   被攻击方"..DATA_Fighting:getVictim("group"))
--			print("   位置"..DATA_Fighting:getVictim("index"))
--			print("   剩余血量"..DATA_Fighting:getVictim("hp"))
--			print("   损失血量"..DATA_Fighting:getVictim("change"))
--			print("第"..DATA_Fighting:getStep().."步结束")
--			local winner = DATA_Fighting:nextStep()
--			if winner then
--				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(process)
--				print("战斗结束，胜利方是"..winner)
--			end
--		end,0.2,false)
	this.layer:addChild(this.roleLayer)
	this.layer:addChild(this.effect:getLayer())
	
	--战斗开始
	this:fightLogic()
	return this
end

function FightLayer:fightLogic()
	local data = DATA_Fighting
	self.group[data:getAttacker("group")][data:getAttacker("index")]:doAction(self,data:getAttackType())
end
 

function FightLayer:getLayer()
	return self.layer
end

return FightLayer