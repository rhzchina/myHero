local PATH = "image/scene/fighting/"
local KNBtn = require "GameLuaScript/Common/KNBtn"
local FightLayer = {
	layer
}

function FightLayer:new()
local this = {}	
	setmetatable(this,self)
	self.__index = self
	
	this.layer = display.newLayer()
	
	local bg = display.newSprite(PATH.."fightingbg1.png")	
	setAnchPos(bg)	
	this.layer:addChild(bg)
	
	local exit = KNBtn:new(PATH,{"fighting_quit.png"},420,800,{
		scale = true,
		callback = 
		function()
			switchScene("home")
		end})
	this.layer:addChild(exit:getLayer())
	return this
end

function FightLayer:getLayer()
	return self.layer
end

return FightLayer