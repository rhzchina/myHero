DATA_Chat = {}
local _data

function DATA_Chat:set(...)
	if arg["n"] == 1 then
		_data = arg[1]
		return 
	end
	
	local result = _data
	for i = 1, arg["n"] do 
		if i == arg["n"] - 1 then
			result[arg[i]] = arg[i + 1]
			break
		else
			if not result[arg[i]] then
				result[arg[i]] = {}
			end
			result = result[arg[i]]
		end 
	end
end

function DATA_Chat:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]..""]
		
		if not result then
			dump(arg)		
			print(arg[i],"取到resut为空")
			break
		end
	end
	return result
end

function DATA_Chat:addMsg(kind, data)
	if #_data[kind] >= 20 then
		table.remove(_data[kind], 1)
	end
	_data[kind][#_data[kind] + 1] = data	
end
