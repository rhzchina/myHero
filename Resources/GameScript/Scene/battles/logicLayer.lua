--[[

战斗逻辑层

]]


local M = {}


local pause         -- 战斗控制器,控制暂停与否
local cur_turn 	    -- 当前轮次
local cur_step      -- 当前步骤
local action_turn   -- 正在播放的轮次
local action_step   -- 正在播放的步骤
local layers		-- 各种层


-- 数据初始化
function M:init()
	pause = {}			-- 战斗控制器,控制暂停与否,可存放多个锁
	cur_turn = 1  		-- 当前轮次
	cur_step = 1  		-- 当前步骤
	action_turn = 1  	-- 正在播放的轮次
	action_step = 1  	-- 正在播放的步骤
	layers = {}		 	-- 各种层
end


function M:create( )
	M:init()


	local main_layer = CCLayer:create()

	-- 获取战斗数据
	local report = DATA_Battle:get("report")


	local prepare_data = report["prepare"]


	-- 英雄卡牌层
	local heroLayer = require("GameScript/Scene/battle/heroLayer")
	layers["hero"] = heroLayer:create()
	main_layer:addChild( layers["hero"] )

	-- 幻兽层
	local petLayer = require("GameScript/Scene/battle/petLayer")
	layers["pet"] = petLayer:create( prepare_data["p1_pet"] )
	main_layer:addChild( layers["pet"] )

	-- 主人技层
	local masterSkillLayer = require("GameScript/Scene/battle/masterSkillLayer")
	layers["masterSkill"] = masterSkillLayer:create( prepare_data["p1_master_skill"] )
	main_layer:addChild( layers["masterSkill"] )

	-- 特效层
	local effectLayer = require("GameScript/Scene/battle/effectLayer")
	layers["effect"] = effectLayer:create()
	main_layer:addChild( layers["effect"] )

	

	--[[开始循环战斗逻辑]]
	M:begin()


    return main_layer
end


--[[战斗开始]]
function M:begin()
	local handle

	-- 游戏定时器, 0.1秒触发一次
	local function tick()
		-- 判断是否暂停状态
		if table.nums(pause) > 0 then return end

		-- 展示下一步
		local ret = M:next()

		-- 判断战斗是否结束
		if ret == false then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
			handle = nil

			-- 显示结果页面
			echoLog("BATTLE" , "End , Winner is " .. DATA_Battle:get("win"))

			local resultLayer = require("GameScript/Scene/battle/resultLayer")
			local scene = display.getRunningScene()
			scene:addChild( resultLayer:create() )
		end
	end

	-- 触发定时器
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick , 0.05 , false)
end


--[[暂停]]
function M:pause( id )
	id = id or "normal"

	pause[id] = true
--[[
	if id ~= nil and type(id) ~= "boolean" then
		-- 特殊锁, 只有当现在没有特殊锁的时候，才能锁定
		if type(pause) == "boolean" then
			pause = id
		end
	else
		-- 一般锁，直接加锁
		pause = true
	end
]]
end


--[[恢复]]
function M:resume( id )
	id = id or "normal"

	if isset(pause , id) then
		pause[id] = nil
	end

--[[
	if type(pause) ~= "boolean" then
		-- 特殊锁, 锁名和id一致，才能解锁
		if id == pause then
			pause = false
		end
	else
		-- 一般锁，直接解锁
		pause = false
	end
]]
end


--[[下一步]]
function M:next()
	local step_data = DATA_Battle:getStep(cur_turn , cur_step)

	if step_data == nil then
		-- 如果已经是第三个回合了，证明整个战斗结束了
		if cur_turn == 3 then return false end

		-- 否则的话，再往后面找一步
		cur_turn = cur_turn + 1
		cur_step = 1

		return M:next()
	end

	-- 记录正在播放的步骤
	action_turn = cur_turn
	action_step = cur_step
	echoLog("BATTLE" , "turn: " .. action_turn .. " , step: " .. action_step .. " , type: " .. step_data["type"])

	-- 停止战斗，等待回调
	local step_type = step_data["type"]
	if step_type == "skip" then
		-- 跳过
	else
		M:pause()
		local step_action = require("GameScript/Scene/battle/step/" .. step_type)
		step_action:run( step_data["type"] , step_data["data"] )
	end


	-- 计数到下一步
	cur_step = cur_step + 1

	return true
end


function M:getActionTurn()
	return action_turn
end

function M:getActionStep()
	return action_step
end


--[[获取对应层]]
function M:getLayer(name)
	return layers[name]
end



return M
