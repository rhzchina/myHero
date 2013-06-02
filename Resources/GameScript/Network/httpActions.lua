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

function M.Battle_up( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Embattle:set(data["battle"])
			DATA_Dress:set(data["equipage"])
			DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
			callback()
		end
	end
	return true,data
end

function M.Battle_replace( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			dump(data)
			DATA_Embattle:set(data["battle"])
--			DATA_Dress:set(data["equipage"])
--			DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
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

function M.Task_map(type, data, callback)
	if type == 1 then
	else
		local curLevel  --当前的小关卡数据是第几关
		local result = data
		curLevel = math.floor(result["hurdle"]["sHurdle"][1]["id"] / 100) % 10
		
		DATA_Mission:setByKey("bHurdle",data["hurdle"]["bHurdle"])
		DATA_Mission:setByKey("sHurdle",curLevel,data["hurdle"]["sHurdle"])
		callback()
	end
	return true, data
end

function M.Task_select_hurdle( type , data , callback )
	if type == 1 then
	else
		local curLevel  --当前的小关卡数据是第几关
		local result = data
		curLevel = math.floor(result["hurdle"][1]["id"] / 100) % 10
		DATA_Mission:setByKey("sHurdle", curLevel, data["hurdle"])
		callback()
	end
	return true,data
end

function M.Skill_selectline(type, data, callback)
	if type == 1 then
	else
		local result = data
		DATA_Dress:set(result["equipage"])
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

function M.Shop_select(type, data, callback)
	if type == 1 then
	else
		DATA_Shop:set(data["shop"])
		callback()
	end
	return true,data
end


function M.Shop_buy(type, data, callback)
	if type == 1 then
	else
		dump(data)
		if data["shop"]["Money"] then
			DATA_User:setkey("Money", data["shop"]["Money"])
		else
			DATA_User:setkey("Gold", data["shop"]["Gold"])
		end
		callback()
	end
	return true,data
end
return M
