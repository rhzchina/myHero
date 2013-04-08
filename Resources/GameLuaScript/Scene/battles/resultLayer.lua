--[[

战斗结果

]]


local M = {}


function M:create( )
	local layer = display.newLayer()

	-- 添加战斗背景图片
	local result_sprite = display.newSprite("image/battle/result.png")
	display.align(result_sprite , display.CENTER , display.cx , display.cy)

	local KNMask = require("GameLuaScript/Common/KNMask")
	mask = KNMask.new({item = result_sprite})
	layer:addChild( mask )

	-- 点击返回首页
	mask:click(function()
		local battle_call_data = {
			report_id = DATA_Battle:get("report_id"),
		}
		SOCKET:getInstance("battle"):call("mission" , "execute_finish" , "finish" , battle_call_data , {
			success_callback = function(err)
				switchScene("home")
			end
		})
	end)
	
    
    return layer
end

return M
