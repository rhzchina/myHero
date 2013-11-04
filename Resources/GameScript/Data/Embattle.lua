DATA_Embattle = {}

local _data

function DATA_Embattle:set(data)
	_data = data
end

--检查英雄是否上阵列
function DATA_Embattle:isOn(cid)
	local on
	for k, v in pairs(_data) do
		if tonumber(v.cid) == tonumber(cid) then
			on = true
			break
		end	
	end
	return on
end

function DATA_Embattle:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]]
		
		if not result then
--			dump(_data[arg[1]])
--			dump(arg)		
--			print(arg[i],"取到resut为空")
			break
		end
	end
	return result
end

function DATA_Embattle:getLen()
	return table.nums(_data)
end

function DATA_Embattle:getnum()
	local num = 0
	for k,v in pairs(_data) do
		if _G.next(v) ~= nil then
			num = num + 1
		end
	end
	return num
end

function DATA_Embattle:isLegal()
	return _data ~= nil
end
