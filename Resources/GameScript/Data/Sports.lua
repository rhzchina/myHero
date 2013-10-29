DATA_Sports = {}

local _data = {}
local _data1 = {}
local _data2 = {}

function DATA_Sports:set_data(data)
	_data = data
end

function DATA_Sports:set_data_key(s_id,num)
	for k,v in pairs(_data) do
		if tonumber(v.Id) == tonumber(s_id) then
			_data[k]["num"] = num
		end
	end
end

function DATA_Sports:set_time(data)
	_data1 = data
end

function DATA_Sports:set_time_key(key,data)
	_data1[key] = data
end

function DATA_Sports:set_record(data)
	_data2 = data
end

function DATA_Sports:set_record_key(data)
	local is_true = false
	for k,v in pairs(_data2) do
		if v.name == data.name then
			_data2[k] = data
			is_true = true
		end
	end
	
	if is_true == false then
		if #_data2 >= 20 then
			table.remove(_data, 1)
		end
		_data2[#_data2 + 1] = data
	end
	
end



function DATA_Sports:get_data()
	return _data 
end

function DATA_Sports:get_time()
	return _data1 
end

function DATA_Sports:get_record()
	return _data2 
end