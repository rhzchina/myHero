DATA_Sports = {}

local _data = {}
local _data1 = {}
local _data2 = {}

function DATA_Sports:set_data(data)
	_data = data
end

function DATA_Sports:set_time(data)
	_data1 = data
end

function DATA_Sports:set_record(data)
	_data2 = data
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