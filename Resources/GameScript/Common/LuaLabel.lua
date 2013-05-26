--[[

		换行文本条 可设置行间距

]]--
local M = {}
--h
function M:new(_str , fontSize , w , h, params)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	local params = params or {}	
	
	local data = _str
	if fontSize == nil then fontSize = 0 end
	local layer_child = display.newLayer()
	local line = 0 --行数
	local num = {}
	local index = 0
	local font_h = 0
	num[line] = 0
	for i = 0,this:utf8_length(data) do
		local label = newLabel(this:utf8_sub(data,index,i+1) , fontSize)
		font_h = label:getContentSize().height
		if label:getContentSize().width > w then
			line = line +1
			index = i + 1
			num[line] = i + 1
		end
	end
	num[line + 1] = this:utf8_length(data)
	for i = 0,line do
		local title_font = newLabel(this:utf8_sub(data,num[i],num[i+1]), fontSize, {y = 30 -((i)*(font_h + h)) }  )
		layer_child:addChild( title_font )
	end
	 return layer_child
end


function M:utf8_length(str)
	local len = 0
	local pos = 1
	local length = string.len(str)
	while true do
		local char = string.sub(str , pos , pos)
		local b = string.byte(char)
		if b >= 128 then
			pos = pos + 3
		else
			pos = pos + 1
		end
		len = len + 1
			-- print(word)
			-- print("pos: " .. pos)
		if pos > length then
			break
		end
	end

	return len
end	
	
function M:utf8_sub(str , s , e)
	local t = {}
	local length = string.len(str)
	local pos = 1
	local offset = 1

	while true do		
		local word = nil
		local char = string.sub(str , pos , pos)
		local b = string.byte(char)
		if b >= 128 then
			if offset > s then
				word = string.sub(str , pos , pos + 2)
				table.insert(t , word)
			end

			pos = pos + 3
		else
			if offset > s then
				word = char
				table.insert(t , word)
			end

			pos = pos + 1
		end
		offset = offset + 1
			-- print(word)
			-- print("pos: " .. pos)
		if offset > e or pos > length then
			break
		end
	end

	return table.concat(t)
end
return M