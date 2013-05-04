DATA_Bag = {}

local _data

function DATA_Bag:set(data)
	_data = data
end

function DATA_Bag:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]]
	end
	return result
end