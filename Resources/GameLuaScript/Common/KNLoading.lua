--[[

loading

** Return **
    CCLayerColor

]]

local M = {}

local KNMask = require("GameLuaScript/Common/KNMask")

function M.new(args)
	local args = args or {}

	local click = args.click or function() end  -- 点击回调函数


	local sprite = display.newSprite("image/loading.png")
	display.align(sprite , display.CENTER , display.cx , display.cy)

	local action = CCRepeatForever:create( CCRotateBy:create(0.5 , 180) )
	sprite:runAction(action)
	
	local view = KNMask.new({item = sprite , click = click})

	return view
end

return M
