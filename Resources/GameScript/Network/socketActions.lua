local M = {}

function M.log_in(type, data, callback)
	if type == 1 then
	else
		print("已返回.."..data)	
	end
	return true, data
end
return M