DATA_Dress = {}

local _data

function DATA_Dress:set(data)
	_data = data
	dump(data)
end

function DATA_Dress:get(...)
	local result = _data
	for i = 1, arg["n"] do
		result = result[arg[i]..""]
		
		if not result then
--			dump(_data[arg[1]])
--			dump(arg)		
			print(arg[i],"取到resut为空")
			break
		end
	end
	return result
end

---检测对应武器或装备是否已使用
function DATA_Dress:isUse(cid)
	local use, role, pos
	for k, v in pairs(_data) do
		for sk, sv in pairs(v) do
			if tonumber(sv.cid) == tonumber(cid) then
				use = true
				role = k
				pos = sk
				break
			end
		end
		
		if use then
			break
		end
	end
	return use, role, pos
end

function DATA_Dress:isLegal()
	return _data ~= nil
end
	
