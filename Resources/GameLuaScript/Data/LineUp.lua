DATA_LineUp = {}


-- 私有变量
local _data = {}

function DATA_LineUp:set(data)
	--_data = {}
	_data = data
end


function DATA_LineUp:get(key)
	return _data[key]
end

function DATA_LineUp:size()
	return table.getn(_data)
end

