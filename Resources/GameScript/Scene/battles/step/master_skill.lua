--[[

普通攻击

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")
local effectLayer = require("GameScript/Scene/battle/effectLayer")

--[[执行]]
function M:run( type , data )
	-- echoLog("BATTLE" , "master_skill")
	MsgBox.getInstance():flashShow("释放主人技")

	effectLayer:changeActions( data["change"] )

	logic:resume()
end


return M
