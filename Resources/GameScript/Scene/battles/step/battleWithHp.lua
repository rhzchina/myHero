--[[

普通攻击

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")

--[[执行]]
function M:run( type , data )
	echoLog("BATTLE" , "battleWithHp")

	logic:resume()
end


return M
