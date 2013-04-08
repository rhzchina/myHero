--[[

战斗队列排列

]]--


local M = {}

local logic = require("GameLuaScript/Scene/battle/logicLayer")
local heroCell = require("GameLuaScript/Scene/battle/heroCell")

function M:create()
	local content = display:newLayer()

	heroCell:init( true )
	
	return content
end
return M