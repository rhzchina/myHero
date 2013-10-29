DATA_Transcript= {}

local _data

function DATA_Transcript:set(data)
	_data = data
end

function DATA_Transcript:set_index(data,index)
	local reust = {}
	dump(data)
	print(index)
	for k,v in pairs(_data) do
		if tonumber(k) == tonumber(index) then
			reust[k] = data
		else
			reust[k] = v
		end
	end
	dump(reust)
	_data = reust
end

function DATA_Transcript:get(...)
	local result = _data
	return result
end