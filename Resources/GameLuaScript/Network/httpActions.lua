--[[

所有 socket 通信发送前以及回调

]]

--[[包含所有 DATA]]
require("GameLuaScript/Data/Session")
require("GameLuaScript/Data/User")
require("GameLuaScript/Data/Battle")
require("GameLuaScript/Data/LineUp")
require("GameLuaScript/Data/FrontRow")
require("GameLuaScript/Data/CardInfo")
require("GameLuaScript/Data/CardAll")
require("GameLuaScript/Data/MapNum")
require("GameLuaScript/Data/MapSmall")
require("GameLuaScript/Data/Fighting")

local M = {}

--[[登录]]
function M.Landed( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		-- 回调处理
		--print(data["code"])
		local result = data

		-- 存储数据
		DATA_Session:set({ uid = result["userinfo"]["uid"] , sid = result["userinfo"]["sid"] , server_id = result["userinfo"]["server_id"] })
		DATA_User:set(result["Userdata"])
		DATA_Battle:set(result["battle"])
		--DATA_Account:set( result["_G_account"] )
		--DATA_Power:set(result["_G_power"])
		--DATA_Energy:set(result["_G_energy"])
		-- 登录成功后，跳转到首页
		switchScene("home")
	end

	return true , data
end

function M.Battle( type , data , callback )
	if type == 1 then
	else
		local result = data
		if result["type"] == 1 then

		elseif result["type"] == 2 then

		elseif result["type"] == 3 then
			DATA_LineUp:set(result["battle"])
			DATA_Battle:set(result["battle"])
		elseif result["type"] == 4 then
			DATA_FrontRow:set(result["select"])
		end
		callback()
	end
	return true,data
end

function M.AddHero( type , data , callback )
	if type == 1 then
	else
		local result = data
		if result["type"] == 1 then

		elseif result["type"] == 2 then

		elseif result["type"] == 3 then
			DATA_CardInfo:set(result["select"])

		elseif result["type"] == 4 then

			DATA_CardAll:set(result["all"])
		end
		callback()
	end
	return true,data
end

function M.Task( type , data , callback )
	if type == 1 then
	else
		local result = data
		if result["type"] == 1 then
			dump(result)
			DATA_MapNum:set(result["hurdle"]["bHurdle"])
			DATA_MapSmall:set(result["hurdle"]["sHurdle"])
		elseif  result["type"] == 2  then

		end

		callback()
	end
	return true,data
end

function M.Fighting(type,data,callback)
	if type == 1 then
	else
		DATA_Fighting:set(data["start"])
		callback()
	end
	return true,data
end

return M
