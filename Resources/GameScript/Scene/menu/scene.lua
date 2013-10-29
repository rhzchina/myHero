--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local Menu = requires(SRC.."Scene/menu/menulayer")



local M = {}

function M:create()
	local scene = display.newScene("menu")

	---------------插入layer---------------------
	scene:addChild( Menu:create():getLayer())
	---------------------------------------------

	return scene
end

return M
