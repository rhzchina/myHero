--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local loginbox_layer = require(SRC.."Scene/login/loginbox")



local M = {}

function M:create()
	local scene = display.newScene("login")

	---------------插入layer---------------------
	scene:addChild( loginbox_layer:create() )
	---------------------------------------------

	return scene
end

return M
