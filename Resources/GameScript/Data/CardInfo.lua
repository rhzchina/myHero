DATA_CardInfo = {}

-- 私有变量
local _data = {}

function DATA_CardInfo:set(data)
	--_data = {}
	_data = data
end


function DATA_CardInfo:get(key)
	return _data[key]
end

function DATA_CardInfo:size()
	return table.getn(_data)
end

