--[[

登录态数据

]]


DATA_Battle = {}


-- 私有变量
local _data = {}

function DATA_Battle:set(data)
	_data = data
end


function DATA_Battle:get(key)
	if key == nil then return _data end

	return _data[key]
end

function DATA_Battle:size()
	return table.getn(_data)
end

