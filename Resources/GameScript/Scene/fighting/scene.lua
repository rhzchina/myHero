--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local FightingLayer = require "GameScript/Scene/fighting/fightinglayer"



local M = {}

function M:create()
	local scene = display.newScene("fighting")

	---------------插入layer---------------------
	scene:addChild(FightingLayer:new():getLayer())
	---------------------------------------------

	return scene
end

return M
