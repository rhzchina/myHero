--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local bagLayer = require "GameScript/Scene/bag/baglayer"



local M = {}

function M:create()
	local scene = display.newScene("login")

	---------------插入layer---------------------
	scene:addChild( bagLayer:create() )
	scene:addChild(InfoLayer:create("lineup"):getMainView())
	scene:addChild(msgLayer:create(0,804))
	scene:addChild(MHLayer:create(0,686))
	---------------------------------------------

	return scene
end

return M
