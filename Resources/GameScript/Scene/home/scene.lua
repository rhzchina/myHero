--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
require "GameScript/Scene/home/homelayer"
require "GameScript/Scene/home/LineUp"

require "GameScript/Scene/common/infolayer"
--require "GameScript/UI/BTLayerLua"



local M = {}

function M:create()
	local scene = display.newScene("home")

	---------------插入layer---------------------
	scene:addChild(HomeLayer:create(0,0))

--	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create("home"):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
