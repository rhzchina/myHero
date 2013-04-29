--[[

普通攻击

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")
local heroCell = require("GameScript/Scene/battle/heroCell")
local effectLayer = require("GameScript/Scene/battle/effectLayer")


--[[执行]]
function M:run( type , data )
--	local frames = display.newFramesWithImage("image/pet/250/action.png" , 6)
--	local sprite

--	sprite = display.playFrames(
--		0,
--		0,
--		frames,
--		0.2,
--		{
--			onComplete = function()
--				effectLayer:changeActions( data["change"] )
--
--				sprite:removeFromParentAndCleanup(true)	-- 清除自己
--				logic:resume()
--			end
--		}
--	)
--	display.align(sprite , display.CENTER , display.cx , display.cy)

	--幻兽动画
	AnimatePacker:getInstance():loadAnimations("image/pet/250/brid_config.xml")
	local apsprite = display.newSprite("image/pet/250/brid.png")
	local function clearSelf()
		effectLayer:changeActions( data["change"] )
		
		apsprite:removeFromParentAndCleanup(true)	-- 清除自己
		
		logic:resume()
	end
	display.align(apsprite , display.CENTER , display.cx , display.cy)
	apsprite:runAction(transition.sequence({AnimatePacker:getInstance():getAnimate("birdAction") , CCCallFunc:create(clearSelf)}))
	

	-- 添加到 幻兽层
	logic:getLayer("pet"):addChild( apsprite )
end


return M
