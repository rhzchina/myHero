VERSION = "13.10.03.01"

local M = {}
function M:create()
	local o = {}
	setmetatable(o , self)
	self.__index = self
	return o
end

function M:get_VERSION()
	local str_version = string.split(VERSION , ".")
	local str_url = ""
	for i,v in pairs(str_version) do
		str_url = str_url .. v
	end
	self.versions = str_url
	return self.versions
end

function M:get_font()
	return VERSION
end

return M