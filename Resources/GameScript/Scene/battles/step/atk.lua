--[[

普通攻击

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")
local heroCell = require("GameScript/Scene/battle/heroCell")
local effectLayer = require("GameScript/Scene/battle/effectLayer")


--[[执行]]
function M:run( type , data )
		-- 攻击方
	local atk_data = data["atk"][1]		-- 普通攻击，肯定只有一个攻击者
	local atk_hero = heroCell:get( atk_data["group"] , atk_data["index"] )

	-- 被攻击方
	local be_atk_data = data["be_atk"][1]	-- 普通攻击，肯定只有一个被攻击者
	local be_atk_hero = heroCell:get( be_atk_data["group"] , be_atk_data["index"] )


	--[[播放动画]]
	local heroAction_move = require("GameScript/Scene/battle/heroAction/move")
	local heroAction_attack = require("GameScript/Scene/battle/heroAction/attack")
	local heroAction_be_attack = require("GameScript/Scene/battle/heroAction/be_attack")

	heroAction_move:move(atk_hero , be_atk_hero , {
		-- 移动过去后的回调
		onComplete = function()
			-- 挥舞动作
			heroAction_attack:wave( atk_hero , {
				onComplete = function()
					-- 受击
					--[[
					heroAction_be_attack:normal( be_atk_hero , {
						
					})
					]]

					-- 掉血
					effectLayer:changeActions( data["change"] )

					-- 回来
					heroAction_move:moveback( atk_hero , {
						onComplete = function()
							-- 恢复战斗进程
							logic:resume()
						end,
					})
				end
			})

			-- 攻击效果(刀光)
			heroAction_attack:normal( atk_hero )
		end
	})

end


return M
