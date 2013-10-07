--[[

首页场景

]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local chat = requires(SRC.."Scene/chat/chatlayer")



local M = {}

function M:create(data)
	local scene = display.newScene("chat")
	---------------插入layer---------------------
	local ins = chat:new(data)
	scene:addChild(ins:getLayer())
	scene:addChild(InfoLayer:create():getLayer())
	
	function scene:refresh()
		ins:refresh()
	end

	return scene
end

return M
