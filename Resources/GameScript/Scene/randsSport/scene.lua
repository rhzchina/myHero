--[[

登录场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local Menu = requires(SRC.."Scene/randsSport/Sportlayer")



local M = {}

function M:create(data)
	local scene = display.newScene("randsSport")

	---------------插入layer---------------------
	scene:addChild( Menu:create(data):getLayer())
	scene:addChild(InfoLayer:create(false):getLayer())
	---------------------------------------------

	return scene
end

return M
