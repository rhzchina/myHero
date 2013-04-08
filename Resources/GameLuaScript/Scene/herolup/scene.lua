--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local hlplayer = require "GameLuaScript/Scene/herolup/herolupLayer"
require "GameLuaScript/Scene/common/infolayer"
require "GameLuaScript/Scene/home/InformationBox"
require "GameLuaScript/Scene/home/MessageHeader"


local M = {}

function M:create()
	local scene = display.newScene("herolup")


	---------------插入layer---------------------
	scene:addChild(msgLayer:create(0,804))
	scene:addChild(MHLayer:create(0,686))
	local herolineupLayer = hlplayer:new(0,88)
	scene:addChild(herolineupLayer:getLayer())
	scene:addChild(InfoLayer:create("lineup"):getMainView())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
