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
	---------------------------------------------

	return scene
end

return M
