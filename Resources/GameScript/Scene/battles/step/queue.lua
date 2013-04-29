--[[

列阵

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")
local heroCell = require("GameScript/Scene/battle/heroCell")

--[[执行]]
function M:run( type , data )
	heroCell:init()

	local hero		-- 英雄
	local hero_layer = logic:getLayer("hero")

	-- 英雄点击事件
	local function hero_click(_data)
		logic:pause("heroinfo")

		KNMsg.getInstance():boxShow(_data["name"] .. "\n血:" .. _data["org_hp"] .. "  攻:" .. _data["atk"] .. "  防:" .. _data["def"] .. "  敏:" .. _data["agi"] , {
			confirmFun = function()
				logic:resume("heroinfo")
			end
		})
	end

	-- 创建已方英雄队列
	local p1_total_time = 0
	for i = 1 , #data.p1 do
		hero = heroCell.new( data.p1[i] , { click = hero_click } )
		hero:setAnchorPoint( ccp(0 , 0) )
		hero:setPosition( 12 + (i - 1) * 116 , 216 )
		transition.playSprites(hero , "fadeIn" , {
			time = 0.3,
			-- delay = (i - 1) * 0.2,
		})
		hero_layer:addChild( hero )

		-- 预存储武将的位置与大小
		local size = hero:getPositionAndSize()
		for k , v in pairs(size) do
			hero[k] = v
		end

		p1_total_time = p1_total_time + 0.2
	end
	
	-- 创建对方英雄队列
	local total_time = 0
	for i = 1 , #data.p2 do
		hero = heroCell.new( data.p2[i] , { click = hero_click } )
		hero:setAnchorPoint( ccp(0 , 0) )
		hero:setPosition( 12 + (i - 1) * 116 , 493 )
		transition.playSprites(hero , "fadeIn" , {
			time = 0.3,
			-- delay = (i - 1) * 0.2 + p1_total_time,
		})
		hero_layer:addChild( hero )

		-- 预存储武将的位置与大小
		local size = hero:getPositionAndSize()
		for k , v in pairs(size) do
			hero[k] = v
		end

		total_time = total_time + 0.2
	end

	-- total_time = total_time + p1_total_time
	total_time = 0.35


	-- 延迟执行下一步
	local handle
	local function callback()
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
		handle = nil

		logic:resume()
	end
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(callback, total_time, false)
	
end


return M
