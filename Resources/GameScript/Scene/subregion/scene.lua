--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local roleLayer = requires(SRC.."Scene/subregion/subregionLayer")



local M = {}

function M:create(data)
	local scene = display.newScene("subregion")

	---------------插入layer---------------------
	scene:addChild(roleLayer:new(data):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
