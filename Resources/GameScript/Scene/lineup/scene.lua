--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local lineup = require "GameScript/Scene/lineup/lineuplayer"



local M = {}

function M:create()
	local scene = display.newScene("lineup")

	---------------插入layer---------------------
	scene:addChild(lineup:new(15,60):getLayer())
	scene:addChild(InfoLayer:create(true):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
