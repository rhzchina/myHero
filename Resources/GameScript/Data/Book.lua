DATA_Book= {}

local _data

function DATA_Book:set(data)
	_data = data
end

function DATA_Book:get(...)
	local result = _data
	return result
end