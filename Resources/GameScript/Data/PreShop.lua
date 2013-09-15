DATA_PreShop = {}

local _data

function DATA_PreShop:set(data)
	_data = data
end

function DATA_PreShop:get(...)
	local result = _data
	return result
end