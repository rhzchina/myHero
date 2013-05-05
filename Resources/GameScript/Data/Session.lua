--[[

登录态数据

]]


DATA_Session = {}


-- 私有变量
local _data = {}

function DATA_Session:set(data)
	_data = data
end


function DATA_Session:get(key)
	if key == nil then return _data end

	return _data[key]
end

