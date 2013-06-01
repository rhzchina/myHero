--[[

所有 socket 通信发送前以及回调

]]

--[[包含所有 DATA]]
require("GameScript/Data/Session")
require("GameScript/Data/User")
require("GameScript/Data/Mission")
require("GameScript/Data/Fighting")
require("GameScript/Data/Bag")
require("GameScript/Data/Embattle")
require("GameScript/Data/Dress")
require("GameScript/Data/Shop")
local M = {}

--[[登录]]
function M.Landed( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		-- 回调处理
		local result = data
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
		if data["error"] then
			print(data["error"])	
		else
			if data["type"] == 3 then --武将上阵返回数据
				dump(data)
				DATA_Embattle:set(data["battle"])
				DATA_Dress:set(data["equipage"])
				DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
			end
			callback()
		end
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
		local curLevel  --当前的小关卡数据是第几关
		local result = data
		if result["type"] == 1 then  --当前的关卡数据
			curLevel = math.floor(result["hurdle"]["sHurdle"][1]["id"] / 100) % 10
			
			DATA_Mission:setByKey("bHurdle",data["hurdle"]["bHurdle"])
			DATA_Mission:setByKey("sHurdle",curLevel,data["hurdle"]["sHurdle"])
		elseif  result["type"] == 2  then  --更新关卡数据
			curLevel = math.floor(result["hurdle"][1]["id"] / 100) % 10
			DATA_Mission:setByKey("sHurdle", curLevel, data["hurdle"])
		end
		callback()
	end
	return true,data
end

function M.Skill(type, data, callback)
	if type == 1 then
	else
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

function M.Shop(type, data, callback)
	if type == 1 then
	else
		DATA_Shop:set(data["shop"])
		callback()
	end
	return true,data
end
return M
