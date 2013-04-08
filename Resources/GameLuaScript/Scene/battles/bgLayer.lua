--[[

战斗背景

]]


local M = {}


local logic = require("GameLuaScript/Scene/battle/logicLayer")


function M:create( )
	local layer = display.newLayer()

	-- 添加战斗背景图片
	local bg = display.newSprite("image/battle/battle_bg.jpg")
	display.align(bg , display.CENTER , display.cx , display.cy)
	layer:addChild(bg)


	-- 添加上方边框
	local hero_border_top = display.newSprite("image/battle/hero_border.png")
	display.align(hero_border_top , display.CENTER , display.cx , display.cy + 220)
	layer:addChild(hero_border_top)

	-- 添加下方边框
	local hero_border_bottom = display.newSprite("image/battle/hero_border.png")
	hero_border_bottom:setFlipY(true)
	display.align(hero_border_bottom , display.CENTER , display.cx , display.cy - 220)
	layer:addChild(hero_border_bottom)


	-- 替补，功能不存在，代码暂时写死在这
	for i = 1 , 4 do
		-- 下方替补
		layer:addChild( display.newSprite("image/battle/back.png" , 237 + (i - 1) * 57 , 143) )
		-- 上方替补
		layer:addChild( display.newSprite("image/battle/back.png" , 56 + (i - 1) * 57 , 716) )
	end

	local btn = KNButton:new("friend" , "跳过" , 400 , 840 , function()
		logic:pause("end")

		local resultLayer = require("GameLuaScript/Scene/battle/resultLayer")
		local scene = display.getRunningScene()
		scene:addChild( resultLayer:create() )
	end)
	layer:addChild( btn )

    
    return layer
end

return M
