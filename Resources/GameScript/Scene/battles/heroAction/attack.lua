--[[

英雄动作 (攻击)

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")


--[[执行特效 -- 普通攻击]]
function M:normal( hero , param )
	if type(param) ~= "table" then param = {} end


	-- 计算坐标偏移量
	local offset_y = hero._height
	if hero:getData("_group") == 2 then
		offset_y = -30
	end


	--[[特效开始]]
	local sprite
	-- local attack_img = (hero:getData("_group") == 1 and "image/battle/heroAction/attack.png") or "image/battle/heroAction/attack2.png"

	local frames = display.newFramesWithImage("image/battle/heroAction/attack.png" , 5)
	sprite = display.playFrames(
		hero.x + hero._width / 2,
		hero.y + offset_y,
		frames,
		0.03,
		{
			angle = (hero:getData("_group") == 2 and 180) or nil,
			onComplete = function()
				sprite:removeFromParentAndCleanup(true)	-- 清除自己
				
				-- if param.onComplete then param.onComplete() end
			end
		}
	)
	sprite:setAnchorPoint( ccp(0.5 , 0.5) )

	-- 放到 特效层
	logic:getLayer("effect"):addChild( sprite )
	


	-- 为了让特效慢点，后面步骤快点，所以不是等特效播放完再执行回调，而是用一个时间
	local handle
	local function callback()
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
		handle = nil

		if param.onComplete then param.onComplete() end
	end
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, 0.03, false)


	return true
end


--[[ 远程攻击 ]]
function M:skill( hero , be_hero , param )
	if type(param) ~= "table" then param = {} end

	--[[ 计算攻击角度 ]]
	local angle
	if be_hero._cy == hero._cy then
		angle = 0
	else
		angle = math.atan( (be_hero._cx - hero._cx) / (be_hero._cy - hero._cy) ) * 180 / math.pi
	end
	if hero:getData("_group") == 2 then
		angle = angle + 180
	end


	local sprite
	local frames = display.newFramesWithImage("image/battle/heroAction/skill_attack.png" , 5)
	sprite = display.playFrames(
		hero._cx, 
		hero._cy,
		frames,
		0.04,
		{
			forever = true,
			angle = (angle == 0 and nil) or angle,
		}
	)
	sprite:setAnchorPoint( ccp(0.5 , 0.5) )

	transition.moveTo(sprite , {
		time = 0.35,
		x = be_hero._cx,
		y = be_hero._cy,
		onComplete = function()
			sprite:removeFromParentAndCleanup(true)	-- 清除自己

			if param.onComplete then param.onComplete() end
		end
	})

	-- 放到 特效层
	logic:getLayer("effect"):addChild( sprite )


	-- 为了让特效慢点，后面步骤快点，所以不是等特效播放完再执行回调，而是用一个时间
	--[[
	local handle
	local function callback()
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
		handle = nil

		if param.onComplete then param.onComplete() end
	end
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, 0.03, false)
	]]
end


--[[ 挥舞武器 ]]
function M:wave( hero , param )
	if type(param) ~= "table" then param = {} end

	-- hero:setAnchorPoint( ccp(0.5 , 0.5) )
	transition.rotateTo( hero , {
		time = 0.06,
		angle = -40,
	})
    transition.rotateTo( hero , {
    	delay = 0.08,
    	time = 0.08,
    	angle = 0,
    	easing = "BACKOUT",
    	onComplete = function()
    		if param.onComplete then param.onComplete() end
    	end
    })


    transition.moveTo( hero , {
    	time = 0.08,
    	y = hero._y + 10,
    })
    transition.moveTo( hero , {
    	delay = 0.08,
    	time = 0.06,
    	y = hero._y,
    })
	-- hero:setAnchorPoint( ccp(0 , 0) )
end


return M
