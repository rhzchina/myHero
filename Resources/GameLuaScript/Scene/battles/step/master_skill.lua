--[[

普通攻击

]]


local M = {}

local logic = require("GameLuaScript/Scene/battle/logicLayer")
local effectLayer = require("GameLuaScript/Scene/battle/effectLayer")

--[[执行]]
function M:run( type , data )
	-- echoLog("BATTLE" , "master_skill")
	KNMsg.getInstance():flashShow("释放主人技")

	effectLayer:changeActions( data["change"] )

	logic:resume()
end


return M
