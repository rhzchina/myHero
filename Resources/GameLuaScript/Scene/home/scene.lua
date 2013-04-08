--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
require "GameLuaScript/Scene/home/homelayer"
require "GameLuaScript/Scene/home/InformationBox"
require "GameLuaScript/Scene/home/MessageHeader"
require "GameLuaScript/Scene/home/LineUp"

require "GameLuaScript/Scene/common/infolayer"
--require "GameLuaScript/UI/BTLayerLua"



local M = {}

function M:create()
	local scene = display.newScene("home")

	---------------插入layer---------------------
	scene:addChild(HomeLayer:create(0,0))

	scene:addChild(msgLayer:create(0,804))

	scene:addChild(MHLayer:create(0,697))

	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create("home"):getMainView())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
