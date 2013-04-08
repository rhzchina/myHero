--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local logicLayer = require("GameLuaScript/Scene/battle/logicLayer")
local bgLayer = require("GameLuaScript/Scene/battle/bgLayer")


local M = {}

function M:create()
	local scene = display.newScene("battle")

	-- 战斗ID
	--[[
	local report_id = DATA_Battle:get("report_id")
	local win = DATA_Battle:get("win")
	]]


	---------------插入layer---------------------
	scene:addChild( bgLayer:create() )	-- 背景
	scene:addChild( logicLayer:create() )	-- 战斗逻辑层
	---------------------------------------------


	return scene
end

return M
