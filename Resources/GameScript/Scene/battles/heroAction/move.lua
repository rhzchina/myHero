--[[

英雄动作 (移动)

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")


--[[执行特效 -- 移动过去]]
function M:move( hero , be_hero , param )
	if type(param) ~= "table" then param = {} end


	-- 计算坐标偏移量
	--[[
	local offset_y = -138
	if hero:getData("_group") == 2 then
		offset_y = math.abs( offset_y )
	end
	]]
	local offset_y = -30
	if hero:getData("_group") == 1 then
		offset_y = math.abs( offset_y )
	end


	--[[特效开始]]
	--[[
	transition.moveTo(hero , {
		x = be_hero._x,
		y = be_hero._y + offset_y,
		time = 0.15,
		onComplete = function()
			if param.onComplete then param.onComplete() end
		end
	})
	]]
	transition.moveTo(hero , {
		y = hero._y + offset_y,
		time = 0.20,
		onComplete = function()
			if param.onComplete then param.onComplete() end
		end
	})

	return true
end


--[[执行特效 -- 移动回来]]
function M:moveback( hero , param )
	if type(param) ~= "table" then param = {} end


	--[[特效开始]]
	transition.moveTo(hero , {
--		delay = 0.15,
		x = hero._x,
		y = hero._y,
		time = 0.15,
		onComplete = function()
			if param.onComplete then param.onComplete() end
		end
	})

	return true
end


--[[执行特效 -- 原地跳跃一下]]
function M:jumpOnce( hero , param )
	if type(param) ~= "table" then param = {} end

	-- 计算坐标偏移量
	hero:setAnchorPoint( ccp(0.5 , 0.5) )
	transition.scaleTo(hero , {
		time = 0.2,
		scale = 1.05
	})

	transition.scaleTo(hero , {
		delay = 0.2,
		time = 0.2,
		scale = 1,
		onComplete = function()
			hero:setAnchorPoint( ccp(0 , 0) )
			if param.onComplete then param.onComplete() end
		end
	})

	transition.moveTo(hero , {
		time = 0.2,
		y = hero._y + 10
	})

	transition.moveTo(hero , {
		delay = 0.2,
		time = 0.2,
		y = hero._y
	})

	return true
end


return M
