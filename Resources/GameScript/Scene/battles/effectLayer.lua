--[[

特效层

]]--


local M = {}

local heroCell = require("GameScript/Scene/battle/heroCell")


function M:create( data )
	local layer = display:newLayer()
	
	
	return layer
end


--[[ change 字段公用特效 ]]
function M:changeActions(change_data)
	if type(change_data) ~= "table" then return end

	for i = 1 , #change_data do
		-- 扣血
		local cur_data = change_data[i]
		local cur_hero = heroCell:get( cur_data["group"] , cur_data["index"] )

		cur_hero:setData("hp" , cur_data["hp"])
		cur_hero:refreshViewHp()

		-- 显示掉血动画
		local effect_changeHp = require("GameScript/Scene/battle/effect/changeHp")
		effect_changeHp:run( cur_hero , cur_data["hp_diff"] )

		-- 附加动作
		if isset(cur_data , "actions") then
			-- 闪避
			if cur_data["actions"]["dodge"] then
				local heroAction_dodge = require("GameScript/Scene/battle/heroAction/dodge")
				heroAction_dodge:run( cur_hero )

				local effect_dodge = require("GameScript/Scene/battle/effect/dodge")
				effect_dodge:run( cur_hero )
			end

			-- 暴击
			if cur_data["actions"]["critical"] then
				local effect_critical = require("GameScript/Scene/battle/effect/critical")
				effect_critical:run( cur_hero )
			end

			-- 恢复
			if cur_data["actions"]["recover"] then
				local effect_recover = require("GameScript/Scene/battle/effect/recover")
				effect_recover:run( cur_hero )
			end
		end

		-- 受击效果
		if cur_data["hp_diff"] < 0 then
			local heroAction_be_attack = require("GameScript/Scene/battle/heroAction/be_attack")
			heroAction_be_attack:normal( cur_hero )
		end

		-- 判断这人挂了没
		if cur_data["hp"] <= 0 then
			local heroAction_die = require("GameScript/Scene/battle/heroAction/die")
			heroAction_die:normal( cur_hero , {
				onComplete = function()
					heroCell:clear( cur_data["group"] , cur_data["index"] )
				end
			})

			
		end
	end
end

return M