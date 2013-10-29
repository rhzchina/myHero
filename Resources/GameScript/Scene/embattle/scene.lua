--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local embattle = require (SRC.."Scene/embattle/EmbattleLayer")


local M = {}

function M:create()
	local scene = display.newScene("embattle")


	---------------插入layer---------------------
	scene:addChild(embattle:new():getLayer())
	scene:addChild(InfoLayer:create():getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
