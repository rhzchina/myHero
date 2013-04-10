local PATH = "image/scene/fighting/"
local KNBtn = require "GameLuaScript/Common/KNBtn"
local FightLayer = {
	layer
}

function FightLayer:new()
local this = {}	
	setmetatable(this,self)
	self.__index = self
	
	this.layer = display.newLayer()
	local bg = display.newSprite(PATH.."fightingbg1.png")	
	setAnchPos(bg)	
	this.layer:addChild(bg)
	
	local process 
	local exit = KNBtn:new(PATH,{"fighting_quit.png"},420,800,{
		scale = true,
		callback = 
		function()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(process)
		end})
	this.layer:addChild(exit:getLayer())
	
	
	print("战斗开始")
		DATA_Fighting:getAttackType()
		process = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(
		function()
			print(process,"------------------回合"..DATA_Fighting:getTurn().."-------------")
			print("第"..DATA_Fighting:getStep().."步")
			print("   攻击方"..DATA_Fighting:getAttacker("group"))
			print("   位置"..DATA_Fighting:getAttacker("index"))
			print("   被攻击方"..DATA_Fighting:getVictim("group"))
			print("   位置"..DATA_Fighting:getVictim("index"))
			print("   剩余血量"..DATA_Fighting:getVictim("hp"))
			print("   损失血量"..DATA_Fighting:getVictim("change"))
			print("第"..DATA_Fighting:getStep().."步结束")
			local winner = DATA_Fighting:nextStep()
			if winner then
				CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(process)
				print("战斗结束，胜利方是"..winner)
			end
		end,0.2,false)
	
	return this
end

function FightLayer:getLayer()
	return self.layer
end

return FightLayer