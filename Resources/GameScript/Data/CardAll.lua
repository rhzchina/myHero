DATA_CardAll = {}

-- 私有变量
local _data = {}

function DATA_CardAll:set(data)
	--_data = {}
	_data = data
	dump(data)
end


function DATA_CardAll:get(key)
	return _data[key]
end

function DATA_CardAll:size()
	return table.getn(_data)
end

