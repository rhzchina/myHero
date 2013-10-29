--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local bagLayer = requires(SRC.."Scene/bag/baglayer")



local M = {}

function M:create(params)
	local scene = display.newScene("bag")

	---------------插入layer---------------------
	scene:addChild( bagLayer:create(params) )
	---------------------------------------------

	return scene
end

return M
