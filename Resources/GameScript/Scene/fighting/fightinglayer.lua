local PATH = IMG_SCENE.."fighting/"
local FightRole = require(SRC.."Scene/fighting/fightrole")
local Effect = require(SRC.."Scene/fighting/effect")
local Result = require(SRC.."Scene/common/FightResult")
local data = DATA_Fighting
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
	
	this.layer = CCLayer:create()
	this.roleLayer = CCLayer:create()
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
	local exit = Btn:new(PATH,{"fighting_quit.png"},420,800,{
		scale = true,
		callback = 
		function()
			data:clear()
			switchScene("login")
		end})
	this.layer:addChild(exit:getLayer())
	
	--初始化英雄
	for i, v in pairs(data:getHero()) do
--		this.group[1][i - 1] = FightRole:new(1, v["id"], i - 1,{hp = v["hp"],star = v["star"] ,effect = this.effect}) 
--		this.roleLayer:addChild(this.group[1][i - 1]:getLayer())
		this.group[1][i] = FightRole:new(1, v["id"], i - 1,{hp = v["hp"],star = v["star"] ,effect = this.effect}) 
		this.roleLayer:addChild(this.group[1][i]:getLayer())
	end
	
	--初始化怪兽
	for i,v in pairs(data:getMonster()) do
--		this.group[2][i - 1] = FightRole:new(2, v["id"], i - 1,{hp = v["hp"],star = v["star"],effect = this.effect}) 
--		this.roleLayer:addChild(this.group[2][i - 1]:getLayer())
		this.group[2][i] = FightRole:new(2, v["id"], i - 1,{hp = v["hp"],star = v["star"],effect = this.effect}) 
		this.roleLayer:addChild(this.group[2][i]:getLayer())
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
	self.group[data:getAttacker("group")][data:getAttacker("index")]:doAction(
		data:getAttackType("type"),  --攻击类型
		"adt",                  --角色状态，攻击:adt,被攻击beatt
		function()              --回调,这里当攻击动画开始后，回调 函数为被 攻击者动画，找合适的时间播放 
--			print("--------攻击方-------------")
--			dump(data:getAttacker())
--			print("------------------------")
			--掉血动画
			local num = data:getVictimCount()
			local str
			for i = 1, num do
				if data:getVictim(i,"type") == "blood" then
					str = ":"
				else
					str = ";"
				end
				self.effect:hpChange(data:getVictim(i, "type") or "normal",str,
					data:getVictim(i,"chance"),
					self.group[data:getVictim(i,"group")][data:getVictim(i,"index")]:getX(),
					self.group[data:getVictim(i,"group")][data:getVictim(i,"index")]:getY()
				)
				self.group[data:getVictim(i,"group")][data:getVictim(i,"index")]:setHp(data:getVictim(i,"hp"))
				--被攻击者动画	
				self.group[data:getVictim(i,"group")][data:getVictim(i,"index")]:doAction(
					data:getAttackType("type"),
					"beatt",
					function()
					    if i == num then	
							local winner = data:nextStep()
							if not winner then
								self:fightLogic()
							else
								self.layer:addChild(Result:new(winner,data:getHero(),data:getResult("guanka")):getLayer())	
								data:clear(true)
							end
						end
					end,data:getAttackType("Mode"))
			end
		end,data:getAttackType("Mode"))
end
 

function FightLayer:getLayer()
	return self.layer
end

return FightLayer