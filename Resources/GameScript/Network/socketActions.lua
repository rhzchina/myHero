local M = {}

function M.log_in(type, data, callback)
	if type == 1 then
		
	else
		callback()
	end
	return true, data
end

function M.open(type, data, callback)
	if type == 1 then
	else
		print("已返回..")	
		--dump(data)
	end
	return true, data
end
return M