--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local hlplayer = require "GameScript/Scene/battlere/battleLayer"


local M = {}

function M:create()
	local scene = display.newScene("battlere")


	---------------插入layer---------------------
	local herolineupLayer = hlplayer:new(0,0)
	scene:addChild(herolineupLayer:getLayer())

	scene:addChild(InfoLayer:create("lineup"):getLayer())
	---------------------------------------------

	return scene
end

return M
