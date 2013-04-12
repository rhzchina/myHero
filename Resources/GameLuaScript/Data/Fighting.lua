
local json = require("GameLuaScript/Network/dkjson")
DATA_Fighting = {
}

local _data
local turn = 1 --第几轮
local step = 1 --第几步


function DATA_Fighting:set(data)
	_data = data
end

function DATA_Fighting:getMonster(key)
	if key then
		return _data["mon"][key]
	else
		return _data["mon"]
	end
end

function DATA_Fighting:getHero(key)
	if key then
		return _data["me"][key]
	else
		return _data["me"]
	end
end
--获取攻击类型
function DATA_Fighting:getAttackType()
	if not _data then
		local file = io.open("c:\\fight.txt","r")
		local str = file:read("*a")
		_data = json.decode(str)["start"]	
		file:close()
	end
	return _data["data"][turn][step]["type"]
end

--攻击者数据
function DATA_Fighting:getAttacker(type)
	if type then
		return _data["data"][turn][step]["adt"][type]
	else
		return _data["data"][turn][step]["adt"]
	end
end

--被攻击者数据
function DATA_Fighting:getVictim(type)
	if table.nums(_data["data"][turn][step]["beatt"]) > 0 then
		if type then
			return _data["data"][turn][step]["beatt"][type]
		else
			return _data["data"][turn][step]["beatt"]
		end
	end
	return ":出错++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
end

function DATA_Fighting:getTurn()
	return turn
end

function DATA_Fighting:getStep()
	return step
end

function DATA_Fighting:clear(clearData)
	if clearData then
		_data = nil
	end
	step = 1
	turn = 1
end

function DATA_Fighting:nextStep()
	step = step + 1
	if step > #_data["data"][turn] then
		step = 1
		turn = turn + 1
		if _data["data"][turn] then
			if _data["data"][turn][step]  then
				if _data["data"][turn][step]["gameover"] then
					return _data["data"][turn][step]["gameover"]
				end
			else
				turn = turn + 1
				step = 0
				return DATA_Fighting:nextStep()
			end
		end
	else
		if _data["data"][turn][step] and _data["data"][turn][step]["gameover"] then
			return _data["data"][turn][step]["gameover"]
		end
	end
	return nil
end

