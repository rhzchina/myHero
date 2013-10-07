--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local shopLayer = requires(SRC.."Scene/shop/shoplayer")



local M = {}

function M:create()
	local scene = display.newScene("login")

	---------------插入layer---------------------
	scene:addChild( shopLayer:create() )
	---------------------------------------------

	return scene
end

return M
