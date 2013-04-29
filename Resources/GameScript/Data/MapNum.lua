DATA_MapNum = {}


-- 私有变量
local _data = {}

function DATA_MapNum:set(data)
	--_data = {}
	_data = data
end


function DATA_MapNum:get(key)
	return _data[key]
end

function DATA_MapNum:size()
	return table.getn(_data)
end

