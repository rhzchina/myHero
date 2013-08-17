--[[

首页场景

]]
 
collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local ActivityLayer = require(SRC.."Scene/activity/activitylayer")

require(SRC.."Scene/common/infolayer")



local M = {}

function M:create()
	local scene = display.newScene("home")

	---------------插入layer---------------------
	scene:addChild(ActivityLayer:create(0,0))

--	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create(false):getLayer())
	---------------------------------------------

	return scene
end

return M
