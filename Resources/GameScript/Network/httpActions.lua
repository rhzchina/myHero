--[[

所有 socket 通信发送前以及回调

]]

--[[包含所有 DATA]]
require("GameScript/Data/Session")
require("GameScript/Data/User")
require("GameScript/Data/MapNum")
require("GameScript/Data/MapSmall")
require("GameScript/Data/Fighting")
require("GameScript/Data/Bag")
require("GameScript/Data/Embattle")
require("GameScript/Data/Dress")
local M = {}

--[[登录]]
function M.Landed( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		-- 回调处理
		local result = data
		dump(result)
		-- 存储数据
		DATA_Bag:set(result["bag"])
		DATA_Session:set({ uid = result["userinfo"]["uid"] , sid = result["userinfo"]["sid"] , server_id = result["userinfo"]["server_id"] })
		DATA_User:set(result["Userdata"])
		DATA_Embattle:set(result["battle"])
		switchScene("home")
	end

	return true , data
end

function M.Battle( type , data , callback )
	if type == 1 then
	else
		callback()
	end
	return true,data
end

function M.AddHero( type , data , callback )
	if type == 1 then
	else
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

function M.Skill(type, data, callback)
	if type == 1 then
	else
		dump(data)
		local result = data
		if result["type"] == 3 then --获取英雄装备信息
			DATA_Dress:set(result["equipage"])
		else
		end
		callback()
	end
	return true, data
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