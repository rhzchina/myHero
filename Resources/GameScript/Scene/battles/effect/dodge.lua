--[[

闪避 (闪避的文字飘动)

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")


--[[执行特效]]
function M:run( hero , param )
	if type(param) ~= "table" then param = {} end

	local sprite = display.newSprite("image/battle/effect/dodge.png")
	display.align(sprite , display.CENTER , hero._cx , hero._cy + 90)


	--[[特效开始]]
	sprite:setScale(0.3)
	transition.scaleTo(sprite, {
		time = 0.6,
		scale = 1,
		easing = "ELASTICOUT",
	})

	transition.fadeOut(sprite, {
		delay = 0.8,
		time = 0.4,
		onComplete = function()
			sprite:removeFromParentAndCleanup(true)	-- 清除自己

			if param.onComplete then param.onComplete() end
			-- print(">>>>>>>>>>>>>>>>>>>>>>>>>> EFFECT [changeHp] is over <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
		end
	})

	-- 添加到 特效层
	logic:getLayer("effect"):addChild( sprite )

	return true
end


return M
