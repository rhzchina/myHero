--[[

首页场景

]]
 
collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
	local ActivityLayer = requires(SRC.."Scene/athletics/athleticslayer")

requires(SRC.."Scene/common/infolayer")



local M = {}

function M:create(data)
	local scene = display.newScene("home")

	---------------插入layer---------------------
	scene:addChild(ActivityLayer:create(data))

--	scene:addChild(LULayer:create(0,493))

	scene:addChild(InfoLayer:create(false):getLayer())
	---------------------------------------------

	return scene
end

return M
