DATA_Mail = {}

local _data

function DATA_Mail:set(data)
	_data = data
end

function DATA_Mail:get(...)
	local result = _data
	return result
end
