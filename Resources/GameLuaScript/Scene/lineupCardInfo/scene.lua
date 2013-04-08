--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local cardinfo = require "GameLuaScript/Scene/lineupCardInfo/CardInfoLayer"
require "GameLuaScript/Scene/common/infolayer"



local M = {}

function M:create()
	local scene = display.newScene("lineupCardInfo")

	---------------插入layer---------------------
	local card = cardinfo:new(15,60)
	scene:addChild(card:getLayer())
	scene:addChild(InfoLayer:create("lineup"):getMainView())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
