--[[

所有 socket 通信发送前以及回调

]]

--[[包含所有 DATA]]
require("GameLuaScript/Data/Session")
require("GameLuaScript/Data/User")
require("GameLuaScript/Data/Account")
require("GameLuaScript/Data/General")
require("GameLuaScript/Data/Formation")
require("GameLuaScript/Data/Battle")


local M = {}

--[[关卡-战斗开始]]
function M.mission_execute( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		DATA_Battle:set( data["result"] )
		
		switchScene("battle")
	end

	return true , data
end



--[[关卡-战斗过程]]
function M.mission_execute_process( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		DATA_Battle:set( data["result"] )

		-- 恢复战斗进程
		local logic = require("GameLuaScript/Scene/battle/logicLayer")
		logic:resume("socket")
	end

	return true , data
end

--[[关卡-战斗完成]]
function M.mission_execute_finish( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		SOCKET:getInstance("battle"):close()
		print("===== 战斗完成 =====")
	end

	return true , data
end


return M