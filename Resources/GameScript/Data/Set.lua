DATA_Set= {}

local _data

function DATA_Set:set(data)
	_data = data
end

function DATA_Set:get(...)
	local result = _data
	return result
end