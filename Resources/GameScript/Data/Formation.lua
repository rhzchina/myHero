--[[

阵法数据

]]


DATA_Formation = {}


-- 私有变量
local _data = {}

function DATA_Formation:set(data)
	_data = data
end


function DATA_Formation:get(key)
	if key == nil then return _data end

	return _data[key]
end
