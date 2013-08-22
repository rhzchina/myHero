DATA_Bag = {}

local _data

function DATA_Bag:set(data)
	_data = data
end


function DATA_Bag:setByKey(...)
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

function DATA_Bag:delItem(first, second)
	_data[first][second]  = nils
end

function DATA_Bag:insert(data)
	for k, v in pairs(data) do
		_data[v.type][k] = v
	end
end


function DATA_Bag:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]..""]
		
		if not result then
--			dump(_data[arg[1]])
			dump(arg)		
			print(arg[i],"取到resut为空")
			break
		end
	end
	return result
end

function DATA_Bag:count(type)
	return table.nums(DATA_Bag:get(type))
end

function DATA_Bag:getByFilter(kind,filter)
	local result = {}
	if type(kind) ~= "table" then
		for k, v in pairs(_data[kind]) do
			if v["filter"] then
				if v["filter"] == filter or not filter then
					result[k] = v
				end
			else
				result[k] = v
			end
		end	
	else --将table中的数据返回
		for k, v in pairs(kind) do
			for sk, sv in pairs(_data[v]) do
				result[sk] = sv
			end
		end
	end
	return result
end
