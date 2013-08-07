--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local lineup = require(SRC.."Scene/lineup/lineuplayer")



local M = {}

function M:create(data)
	local scene = display.newScene("lineup")

	---------------插入layer---------------------
	scene:addChild(lineup:new(data):getLayer())
	scene:addChild(InfoLayer:create(true):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
