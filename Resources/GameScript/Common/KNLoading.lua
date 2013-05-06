--[[

loading

** Return **
    CCLayerColor

]]

local M = {}


function M.new(args)
	local args = args or {}

	local click = args.click or function() end  -- 点击回调函数


	local sprite = display.newSprite(IMG_COMMON.."loading.png")
	display.align(sprite , display.CENTER , display.cx , display.cy)

	local action = CCRepeatForever:create( CCRotateBy:create(0.5 , 180) )
	sprite:runAction(action)

	local view = Mask:new({item = sprite , click = click})

	return view
end

return M
