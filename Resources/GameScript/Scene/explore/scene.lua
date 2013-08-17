--[[

首页场景

]]
 
collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local ExporeLayer = require(SRC.."Scene/explore/explorelayer")

require(SRC.."Scene/common/infolayer")



local M = {}

function M:create()
	local scene = display.newScene("home")

	---------------插入layer---------------------
	scene:addChild(ExporeLayer:create(0,0))

--	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create(true):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
