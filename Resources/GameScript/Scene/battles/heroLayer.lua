--[[

战斗队列排列

]]--


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")
local heroCell = require("GameScript/Scene/battle/heroCell")

function M:create()
	local content = display:newLayer()

	heroCell:init( true )
	
	return content
end
return M