--[[

用户数据

]]


DATA_User = {}


-- 私有变量
local _data = {}

function DATA_User:set(data)
	_data = data
	dump(data)
end


function DATA_User:setkey(key , data)
	_data[key] = data
end


function DATA_User:get(key)
	if key == nil then return _data end

	return _data[key]
end
