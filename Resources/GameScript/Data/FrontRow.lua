DATA_FrontRow = {}


-- 私有变量
local _data = {}

function DATA_FrontRow:set(data)
	--_data = {}
	_data = data
	dump(data)
end


function DATA_FrontRow:get(key)
	return _data[key]
end

function DATA_FrontRow:size()
	return table.getn(_data)
end

