--[[

英雄动作 (闪避)

]]


local M = {}

local logic = require("GameLuaScript/Scene/battle/logicLayer")


--[[执行特效]]
function M:run( hero , param )
	if type(param) ~= "table" then param = {} end

	local hero_group = hero:getData("_group")

	--[[特效开始]]
	local move_y = -35
	if hero_group == 2 then
		move_y = math.abs(move_y)
	end

	transition.moveTo(hero , {
		time = 0.1,
		y = hero._y + move_y,
	})
	transition.moveTo(hero , {
		delay = 0.1,
		time = 0.08,
		y = hero._y,
	})


	return true
end


return M
