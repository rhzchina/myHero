DATA_Pay= {}

local _data
local _data1
function DATA_Pay:set(data)
	_data = data
end

function DATA_Pay:get(...)
	local result = _data
	return result
end

function DATA_Pay:set_first(data)
	_data1 = data
end

function DATA_Pay:get_first(...)
	local result = _data1
	return result
end
