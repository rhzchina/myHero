DATA_Bag = {}

local _data

function DATA_Bag:set(data)
	_data = data
	dump(_data)
end

function DATA_Bag:setByKey(first, second, third)
	if third then
		if not _data[first] then
			_data[first] = {}
		end
		_data[first][second] = third
	else	
		_data[first] = second
	end
end

function DATA_Bag:insert(type, data)
	for k, v in pairs(data) do
		_data[type][k] = v
	end
end


function DATA_Bag:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]..""]
		
		if not result then
--			dump(_data[arg[1]])
--			dump(arg)		
--			print(arg[i],"取到resut为空")
			break
		end
	end
	return result
end

function DATA_Bag:getByFilter(type,filter)
	local result = {}
	for k, v in pairs(_data[type]) do
		if v["type"] then
			if v["type"] == filter or not filter then
				result[k] = v
			end
		else
			result[k] = v
		end
	end	
	return result
end
