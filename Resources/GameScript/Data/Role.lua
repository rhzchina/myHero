DATA_Role= {}

local _data
local _data1
function DATA_Role:set(data)
	_data = data
end

function DATA_Role:get(...)
	local result = _data
	return result
end

function DATA_Role:set_name(data)
	_data1 = data
end

function DATA_Role:get_name(...)
	local result = _data1
	return result
end