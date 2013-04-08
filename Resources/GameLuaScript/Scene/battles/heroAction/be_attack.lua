--[[

英雄动作 (受击)

]]


local M = {}

local logic = require("GameLuaScript/Scene/battle/logicLayer")


--[[执行特效 -- 刀光]]
function M:normal( hero , param )
	if type(param) ~= "table" then param = {} end


	--[[特效开始]]
	local sprite
	local frames = display.newFramesWithImage("image/battle/heroAction/dao.png" , 3)
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

	-- 震动一下
	local shake_y = ( hero:getData("_group") == 2 and 30 ) or -30
	M:shake( hero , { time = 0.15 , y = shake_y } )

	-- 颜色变红一下
	M:tint( hero , { max_num = 3 , time = 0.06 } )


	-- 放到 特效层
	logic:getLayer("effect"):addChild( sprite )


	return true
end

--[[英雄卡牌稍微震动一下]]
function M:shake( hero , param )
	if type(param) ~= "table" then param = {} end

	transition.shake( hero , {
		time = param.time or 0.12,
		x = param.x or 0,
		y = param.y or -30,
		no_scale = true,
		onComplete = function() 
			if param.onComplete then param.onComplete() end
		end
	})
end

--[[英雄卡牌变红，再变回来]]
function M:tint( hero , param )
	if type(param) ~= "table" then param = {} end

	local cur_num = param.cur_num or 0
	local max_num = param.max_num or 1
	if cur_num >= max_num then return end

	transition.playSprites( hero , "tintTo" , {
		time = param.time or 0.1,
		r = param.r or 200,
		g = param.g or 0,
		b = param.b or 0,
	})

	transition.playSprites( hero , "tintTo" , {
		delay = param.time or 0.1,
		time = param.time,
		r = 255,
		g = 255,
		b = 255,
		onComplete = function() 
			M:tint( hero , { max_num = max_num , cur_num = cur_num + 1 , time = param.time } )

			if param.onComplete then param.onComplete() end
		end
	})

--[[
	transition.tintTo( hero , {
		time = param.time or 0.15,
		r = param.r or 200,
		g = param.g or 0,
		b = param.b or 0,
		onComplete = function()
			transition.tintTo( hero , {
				time = 0.1,
				r = 255,
				g = 255,
				b = 255,
				onComplete = function() 
					if param.onComplete then param.onComplete() end
				end
			})
		end
	})

]]
end



return M
