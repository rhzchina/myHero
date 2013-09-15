DATA_Rands = {}

local _data

local _data_fuben
local top
function DATA_Rands:set_prestige(data)
	_data = data
end

function DATA_Rands:get_prestige(...)
	local result = _data
	return result
end

function DATA_Rands:set_fuben(data)
	_data_fuben = data
end

function DATA_Rands:get_fuben(...)
	local result = _data_fuben
	return result
end

function DATA_Rands:set_top(data)
	top = data
end

function DATA_Rands:get_top(...)
	local result = top
	return result
end