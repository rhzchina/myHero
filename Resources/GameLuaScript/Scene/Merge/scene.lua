--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
require "GameLuaScript/Scene/mission/missionlayer"
require "GameLuaScript/Scene/common/infolayer"



local M = {}

function M:create()
	local scene = display.newScene("mission")

	---------------插入layer---------------------
	scene:addChild(MissionLayer:create(15,60))
	scene:addChild(InfoLayer:create("home"):getMainView())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
