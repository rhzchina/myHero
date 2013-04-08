--[[

暴击 (暴击特效)

]]


local M = {}

local logic = require("GameLuaScript/Scene/battle/logicLayer")


--[[执行特效]]
function M:run( hero , param )
	if type(param) ~= "table" then param = {} end


	--[[特效开始]]
	transition.shake()		-- 屏幕震动


	local sprite
	local frames = display.newFramesWithImage("image/battle/effect/critical.png" , 5)
	sprite = display.playFrames(
		hero._cx, 
		hero._cy,
		frames,
		0.08,
		{
			onComplete = function()
				sprite:removeFromParentAndCleanup(true)	-- 清除自己

				if param.onComplete then param.onComplete() end
			end
		}
	)
	sprite:setAnchorPoint( ccp(0.5 , 0.5) )


	-- 添加到 特效层
	logic:getLayer("effect"):addChild( sprite )

	return true
end


return M
