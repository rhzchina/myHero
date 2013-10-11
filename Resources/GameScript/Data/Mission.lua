DATA_Mission = {}

local _data

function DATA_Mission:set(data)
	_data = data
end

function DATA_Mission:setByKey(first, second, third,four)
	if not _data then
		_data = {}
	end
	
	if four then
		if not _data[first] then
			_data[first] = {}
		end
		_data[first][second][third]= four
	elseif third then
		if not _data[first] then
			_data[first] = {}
		end
		_data[first][second] = third
	else
		_data[first] = second
	end
	
end

function DATA_Mission:set_small_key(first ,second,key, data)
	_data["sHurdle"][first][second][key] = data
end

function DATA_Mission:get(...)
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
