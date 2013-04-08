DATA_MapSmall = {}


-- 私有变量
local _data = {}

function DATA_MapSmall:set(data)
	--_data = {}
	_data = data
end


function DATA_MapSmall:get(key)
	return _data[key]
end

function DATA_MapSmall:get_data()
	return _data
end
function DATA_MapSmall:size()
	return table.getn(_data)
end

