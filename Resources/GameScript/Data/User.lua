--[[

用户数据

]]


DATA_User = {}


-- 私有变量
local _data = {}

function DATA_User:set(data)
	_data = data
end

function DATA_User:setByKey(...)
	local result = _data
	for i = 1, arg["n"] do 
		if i == arg["n"] - 1 then
			result[arg[i]] = arg[i + 1]
			break
		else
			if not result[arg[i]] then
				result[arg[i]] = {}
			end
			result = result[arg[i]]
		end 
	end
end


function DATA_User:setkey(key , data)
	_data[key] = data
end


function DATA_User:get(key)
	if key == nil then return _data end

	return _data[key]
end
