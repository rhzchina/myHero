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
requires(SRC.."Data/Role")
requires(SRC.."Data/Pay")
requires(SRC.."Data/CommonUser")
local M = {}

--[[登录]]
function M.User(type , data , callback )
if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		if data["type"] == 1 then
			DATA_CommonUser:set_user(data["user"])
			DATA_CommonUser:set_server(data["server"])
			DATA_CommonUser:set_other(data["other"])
			FileManager.updatafile("user.txt" , "username" , "=" , data["user"].user_name)
			FileManager.updatafile("user.txt" , "password" , "=" , data["user"].password)
			switchScene("subregion")
		elseif data["type"] == 2 then
			DATA_CommonUser:set_user(data["user"])
			DATA_CommonUser:set_server(data["server"])
			DATA_CommonUser:set_other(data["other"])
			switchScene("subregion")
		elseif data["type"] == 3 then
			if data["enter"] == 0 then
				CONFIG_HTTP_URL = "http://"..data["server"].domain..":"..data["server"].port.."/"
				CONFIG_SOCKET_HOST = data["server"].domain
				CONFIG_SOCKET_PORT = data["server"].socket
				
				HTTPS:send("Landed" , {m="login",a="develop",open_id = DATA_CommonUser:get_user().uid} )
			end
		elseif data["type"] == 4 then
			DATA_CommonUser:set_user(data["user"])
			DATA_CommonUser:set_server(data["server"])
			DATA_CommonUser:set_other(data["other"])
			FileManager.updatafile("user.txt" , "username" , "=" , data["user"].user_name)
			FileManager.updatafile("user.txt" , "password" , "=" , data["user"].password)
			switchScene("subregion")
		end
		
	end

	return true , data
end

function M.Landed( type , data , callback )
	if type == 1 then
		-- 发送前数据处理
	elseif type == 2 then
		-- 回调处理
		local result = data
		dump(data)
		-- 存储数据
		DATA_Bag:set(result["bag"])
		DATA_Session:set({ uid = result["userinfo"]["uid"] , sid = result["userinfo"]["sid"] , server_id = result["userinfo"]["server_id"] })
		DATA_User:set(result["Userdata"])
		DATA_Embattle:set(result["battle"])
		DATA_Role:set(result["role"])
		DATA_Role:set_name(result["role_name"])
		DATA_Dress:set(result["equipage"])
--		SOCKET:getInstance("msg"):call("log" , "in" , "open" , {} , {
--				success_callback = function()
--					switchScene("home")
--				end
--			})
		SOCKET:call("open")
		Thread:create()
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
			if data["icon_id"] then
				DATA_User:setkey("icon_id", data["icon_id"])
			end
			
			if data["icon_start"] then
				DATA_User:setkey("icon_start", data["icon_start"])
			end
			
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


function M.Battle_replace_hero( type , data , callback )
	if type == 1 then
	else
		DATA_Embattle:set(data["battle"])
		DATA_Dress:set(data["equipage"])
		dump(data)
		for k, v in pairs(data["skill"]) do
			if v.change == "delect" then
				DATA_Bag:delItem("skill",k)
			elseif v.change == "add" then
				DATA_Bag:setByKey("skill",k, v)
			end
		end
		callback()
	end
	return true,data
end

function M.Battle_rolename( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Role:set_name(data["role_name"])
			callback()
		end
	end
	return true,data
end

function M.Battle_role( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Embattle:set(data["battle"])
			DATA_Dress:set(data["equip"])
			DATA_Bag:setByKey("skill",data["skill"]["cid"],data["skill"])
			DATA_Bag:setByKey("hero",data["hero"]["cid"],data["hero"])
			DATA_Role:set(data["role"])
			DATA_User:setkey("name", data["name"])
			
			if data["icon_id"] then
				DATA_User:setkey("icon_id", data["icon_id"])
			end
			
			if data["icon_start"] then
				DATA_User:setkey("icon_start", data["icon_start"])
			end
			
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
		DATA_Dress:set(result["equipage"])
		callback()
	end
	return true, data
end

function M.Skill_replace(type, data, callback)
	if type == 1 then
	else
		local result = data
		DATA_Dress:set(result["equipage"])
		callback()
	end
	return true, data
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
		if data["type"] == 1 then
			--任务
			local temp = data["start"]["gameover"]["guanka"]
			
			if temp then
				
				--更新用户数据
				if temp["user"].lv then
					DATA_User:setkey("lv", temp["user"].lv)
				end
				
				if temp["user"].Money then
					DATA_User:setkey("Money", temp["user"].Money)
				end 
				
				if temp["user"].energy then
					DATA_User:setkey("energy", temp["user"].energy)
				end 
				
				if temp["user"].Gold then
					DATA_User:setkey("Gold", temp["user"].Gold)
				end 
				
				if temp["user"].back_num then
					DATA_User:setkey("back_num", temp["user"].back_num)
				end 
				
				if temp["user"].back_num then
					DATA_User:setkey("Exp", temp["user"].Exp)
				end 
				
				if temp["user"].back_num then
					DATA_User:setkey("Next_Exp", temp["user"].Next_Exp)
				end 
				
				if temp["user"].back_num then
					DATA_User:setkey("steps", temp["user"].steps)
				end 
				
				IS_UPDATA = true
				
				--更新关卡数据				
				if temp["hurdle"] then
					if temp["hurdle"].hurdle_id then
						local bhur_id = math.floor(temp["hurdle"].cur_bHurdle ) %100
						local shur_id = temp["hurdle"].hurdle_id %10 
						DATA_Mission:set_small_key(bhur_id,shur_id,"marked",temp["hurdle"].s_marked)
					end
				end
				
			end
			
			DATA_Fighting:set(data["start"])
		elseif data["type"] == 2 then
			--竞技
			DATA_Fighting:set(data["start"])
			local temp = data["start"]["gameover"]["guanka"]
			if temp then
				if temp["user"].change_prestige then
					DATA_User:setkey("prestige", temp["user"].change_prestige)
				end
				if temp["user"].Gold then
					DATA_User:setkey("Gold", temp["user"].Gold)
				end
			end
			
			if data["add"] then
				DATA_Sports:set_record_key(data["add"])
			end
			
			if data["change"] then
				DATA_Sports:set_record_key(data["change"])
			end
			
			if temp["tast"] then
				if temp["tast"]["s_id"] then
					DATA_Sports:set_data_key(temp["tast"]["s_id"],temp["tast"]["num"])
				end
				if temp["tast"]["time"] then
					DATA_Sports:set_time(temp["tast"]["time"])
				end
				
			end
			IS_UPDATA = true
		elseif data["type"] == 3 then
			--副本
			DATA_Fighting:set(data["start"])
		end
		
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
			IS_UPDATA = true
		else
			DATA_User:setkey("Gold", data["shop"]["Gold"])
			IS_UPDATA = true
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
			elseif v["change"] == "user" then
				if v["energy"] then DATA_User:setkey("energy", v["energy"]) end
				if v["Money"] then DATA_User:setkey("Money", v["Money"]) end
				if v["lv"] then DATA_User:setkey("lv", v["lv"]) end
				if v["Exp"] then DATA_User:setkey("Exp", v["Exp"]) end
				if v["Next_Exp"] then DATA_User:setkey("Next_Exp", v["Next_Exp"]) end
				if v["soul_w"] then DATA_User:setkey("soul_w", v["soul_w"]) end
				if v["soul_b"] then DATA_User:setkey("soul_b", v["soul_b"]) end
				if v["soul_g"] then DATA_User:setkey("soul_g", v["soul_g"]) end
				if v["chat_num"] then DATA_User:setkey("chat_num", v["chat_num"]) end
				if v["Gold"] then DATA_User:setkey("Gold", v["Gold"]) end
				if v["prestige"] then DATA_User:setkey("prestige", v["prestige"]) end
				IS_UPDATA = true
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
		
		--DATA_User:set(data["Userdata"])
		if data["user"].soul_w then
			DATA_User:setByKey("soul_w", data["user"].soul_w)
		end
		
		if data["user"].soul_b then
			DATA_User:setByKey("soul_b", data["user"].soul_b)
		end
		
		if data["user"].soul_g then
			DATA_User:setByKey("soul_g", data["user"].soul_g)
		end
		
		if data["user"].Money then
			DATA_User:setkey("Money", data["user"].Money)
		end
		
		for k, v in pairs(data["hero"]) do
			DATA_Bag:delItem("hero", k)
		end	
		callback()
	end
	return true, data
end

function M.Strong_get_strengthen(kind, data, callback)
	if kind == 1 then
	else
		
		callback(data.pay)
	end
	return true, data
end

function M.Strong_strengthen(kind, data, callback)
	if kind == 1 then
	else
		
		for k, v in pairs(data["data"] or data["equip"]) do
			if v["change"] == "delect" then
				DATA_Bag:delItem(v["type"], k)
			elseif v["change"] == "add" or v["change"] == "updata" then
				DATA_Bag:setByKey(v["type"], k, v)
			end
		end
		callback(data.pay)
	end
	return true, data
end

function M.Strong_equip_get(kind, data, callback)
	if kind == 1 then
	else
		callback(data.pay)
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
			IS_UPDATA = true
		end
		callback(data["exlplore"])
	end
	return true, data
end

function M.Explore_click(kind, data, callback)
	if kind == 1 then
	else
		DATA_User:setByKey("Money", data["Money"])
		IS_UPDATA = true
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

function M.Sports_check(kind, data, callback)
	if kind == 1 then
	else
		DATA_Fighting:set(data["start"])
		callback(data)
	end
	return true, data
end

function M.Sports_refresh(kind, data, callback)
	if kind == 1 then
	else
		if data["Gold"] then 
			DATA_User:setkey("Gold", data["Gold"])
			IS_UPDATA = true
		end
		
		callback(data)
	end
	return true, data
end

function M.Sports_clean(kind, data, callback)
	if kind == 1 then
	else
		DATA_User:setkey("Gold", data["Gold"])
		IS_UPDATA = true
		DATA_Sports:set_time(data["time"])
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
			for k, v in pairs(data["exlploreshop"]["data"]) do
				if v["change"] == "delect" then
					DATA_Bag:delItem(v["type"], k)
				elseif v["change"] == "add" or v["change"] == "updata" then
					DATA_Bag:setByKey(v["type"], k, v)
				end
			end
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

function M.Duplicate_quick(kind, data, callback)
	if kind == 1 then
	else	
		dump(data)
		--callback(data["duplicate"])
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

function M.Pay_get( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			DATA_Pay:set(data["data"])
			DATA_Pay:set_first(data["first"])
			callback(data)
		end
	end
	return true,data
end

function M.Pay_buy( type , data , callback )
	if type == 1 then
	else
		if data["error"] then
			print(data["error"])	
		else
			callback(data)
		end
	end
	return true,data
end

return M
