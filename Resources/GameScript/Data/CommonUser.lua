DATA_CommonUser= {}

local _data
local _data1
local _data2
function DATA_CommonUser:set_user(data)
	_data = data
end

function DATA_CommonUser:get_user(...)
	local result = _data
	return result
end

function DATA_CommonUser:set_server(data)
	_data1 = data
end

function DATA_CommonUser:get_server(...)
	local result = _data1
	return result
end

function DATA_CommonUser:set_other(data)
	_data2 = data
end

function DATA_CommonUser:get_other(...)
	local result = _data2
	return result
end