--[[

所有 socket 通信发送前以及回调

]]

--[[包含所有 DATA]]
requires(SRC.."Data/Session")
requires(SRC.."Data/User")
requires(SRC.."Data/Mission")
requires(SRC.."Data/Fighting")
requires(SRC.."Data/Bag")
requires(SRC.."Data/Embattle")
requires(SRC.."Data/Dress")
requires(SRC.."Data/Shop")
requires(SRC.."Data/Chat")
requires(SRC.."Data/Mail")
requires(SRC.."Data/Rands")
requires(SRC.."Data/PreShop")
requires(SRC.."Data/Sports")
requires(SRC.."Data/Book")
requires(SRC.."Data/Transcript")
requires(SRC.."Data/Set")
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
--		SOCKET:getInstance("msg"):call("log" , "in" , "open" , {} , {
--				success_callback = function()
--					switchScene("home")
--				end
--			})
		SOCKET:call("open")
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
			DATA_Dress:set(data["equip"])
			DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
			
			DATA_User:setkey("icon_id", data["icon_id"])
			DATA_User:setkey("icon_start", data["icon_start"])
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
			DATA_Embattle:set(data["battle"])
--			DATA_Dress:set(data["equipage"])
--			DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
			callback()
		end
	end
	return true,data
end

function M.Battle_seticon( type , data , callback )
	if type == 1 then
	else
		DATA_User:setkey("icon_id", data["icon_id"])
		DATA_User:setkey("icon_start", data["icon_start"])
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
		curLevel = math.floor(result["hurdle"][1]["id"] / 100) % 100
		DATA_Mission:setByKey("sHurdle", curLevel, data["hurdle"])
		callback()
	end
	return true,data
end

function M.Skill_selectline(type, data, callback)
	if type == 1 then
	else
		local result = data
		dump(result)
		DATA_Dress:set(result["equipage"])
		callback()
	end
	return true, data
end

function M.Skill_inserSkill(type, data, callback)
	if type == 1 then
	else
		local result = data
		DATA_Dress:set(result["equipage"])
		callback()
	end
	return true, data
end

function M.Fighting_start(type,data,callback)
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
		if data["shop"]["Money"] then
			DATA_User:setkey("Money", data["shop"]["Money"])
		else
			DATA_User:setkey("Gold", data["shop"]["Gold"])
		end
		DATA_Bag:setByKey("prop", data["shop"]["prop"]["cid"], data["shop"]["prop"])
		callback()
	end
	return true,data
end


function M.Shop_open(type, data, callback)
	if type == 1 then
	else
		for k, v in pairs(data["shop"]) do
			if v["change"] == "delect" then
				DATA_Bag:delItem(v["type"], k)
			elseif v["change"] == "add" then
				DATA_Bag:setByKey(v["type"], k, v)
			end
		end
		callback()
	end
	return true,data
end

function M.Strong_hero_get(type, data, callback)
	if type == 1 then
	else
		callback(data["strong"])
	end
	return true, data
end

function M.Strong_upgrade(kind, data, callback)
	if kind == 1 then
	else
		DATA_User:set(data["Userdata"])
		for k, v in pairs(data) do
			if type(v) == "table" and v.type == "hero" then
				DATA_Bag:setByKey("hero", k, v)
				break
			end
		end
		callback(data["strong"])
	end
	return true, data
end

function M.Strong_resolve(kind, data, callback)
	if kind == 1 then
	else
		DATA_User:set(data["Userdata"])
		
		for k, v in pairs(data["hero"]) do
			DATA_Bag:delItem("hero", k)
		end	
		callback()
	end
	return true, data
end

function M.Activity_open(kind, data, callback)
	if kind == 1 then
	else
		callback(data["exlplore"])
	end	
	return true, data
end

function M.Explore_init(kind, data, callback)
	if kind == 1 then
	else
		callback(data["exlplore"])
	end
	return true, data
end

function M.Explore_execute(kind, data, callback)
	if kind == 1 then
	else
		if not data["exlplore"].msg then
			DATA_User:setByKey("Money", data["exlplore"]["Money"])
		end
		callback(data["exlplore"])
	end
	return true, data
end

function M.Explore_click(kind, data, callback)
	if kind == 1 then
	else
		DATA_User:setByKey("Money", data["Money"])
		callback(data["exlplore"])
	end
	return true, data
end

function M.Activity_check(kind, data, callback)
	if kind == 1 then
	else
		callback(data["exlplore"]["check1"], data["exlplore"]["change"])
	end	
	return true,data
end

function M.Sports_get(kind, data, callback)
	if kind == 1 then
	else
		DATA_Sports:set_data(data["data"])
		DATA_Sports:set_time(data["time"])
		DATA_Sports:set_record(data["record"])
		callback(data)
	end
	return true, data
end
	
function M.Sports_refresh(kind, data, callback)
	if kind == 1 then
	else
		callback(data)
	end
	return true, data
end

function M.Mail_open(kind, data, callback)
	if kind == 1 then
	else
		DATA_Mail:set(data["data"])
		callback(data["data"])
	end
	return true, data
end

function M.Mail_send(kind, data, callback)
	if kind == 1 then
	else
		--DATA_Mail:set(data["data"])
		callback(data["data"])
	end
	return true, data
end



function M.Mail_delect(kind, data, callback)
	if kind == 1 then
	else
		DATA_Mail:set(data["data"])
		callback(data["data"])
	end
	return true, data
end

function M.Ranking_prestige(kind, data, callback)
	if kind == 1 then
	else		
		DATA_Rands:set_prestige(data["data"])
		DATA_Rands:set_top(data["top"])
		callback(data["data"])
	end
	return true, data
end

function M.Ranking_duplicate(kind, data, callback)
	if kind == 1 then
	else	
		DATA_Rands:set_prestige(data["data"])
		DATA_Rands:set_top(data["top"])
		callback(data["data"])
	end
	return true, data
end

function M.Exploreshop(kind, data, callback)
	if kind == 1 then
	else
		if data["type"] == "open" then
			DATA_PreShop:set(data["exlploreshop"])
		elseif data["type"] == "pay" then
			DATA_User:setkey("prestige", data["exlploreshop"]["prestige"])
			DATA_Bag:updata_hero(data["exlploreshop"]["type"],data["exlploreshop"]["add"])
		end
		callback(data["data"])
	end
	return true, data
end

function M.Duplicate_open(kind, data, callback)
	if kind == 1 then
	else		
		DATA_Transcript:set(data["duplicate"])
		callback(data["data"])
	end
	return true, data
end

function M.Duplicate_reset(kind, data, callback)
	if kind == 1 then
	else		
		callback(data["data"])
	end
	return true, data
end

function M.Duplicate_emigrated(kind, data, callback)
	if kind == 1 then
	else		
		callback(data["duplicate"])
	end
	return true, data
end

function M.Duplicate_reset(kind, data, callback)
	if kind == 1 then
	else
		dump(data)
		DATA_Transcript:set_index(data["duplicate"],data.index)
		
		callback(data)
	end
	return true, data
end

function M.Book_open( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Book:set(data)
			callback(data)
		end
	end
	return true,data
end

function M.Book_setting( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Set:set(data)
			callback(data)
		end
	end
	return true,data
end

return M
