--[[

初始化场景

]]


collectgarbage("setpause"  ,  100)
collectgarbage("setstepmul"  ,  5000)

local initCopyLayer = require "GameScript/initialization/init_copyfiles"

local M = {}

function M:create()
	local scene = CCScene:create()
	scene.name = "init"

	require("GameScript/Config/channel")
	if CHANNEL_ID == "uc" or CHANNEL_ID == "cmge" or CHANNEL_ID == "downjoy" or CHANNEL_ID == "DK" then
		local layer = CCLayer:create()
		local bg = CCSprite:create("image/other/" .. CHANNEL_ID .. "_bg.jpg")
		INIT_FUNCTION.setAnchPos( bg , 0 , 0 )
		layer:addChild( bg )
		scene:addChild(layer)

		local handle
		handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
			handle = nil
			INIT_FUNCTION.update = initCopyLayer:new()
			scene:addChild(INIT_FUNCTION.update:getLayer())	
		end , 2 , false)
	else
		INIT_FUNCTION.update = initCopyLayer:new()
		scene:addChild(INIT_FUNCTION.update:getLayer())	
	end
	

	return scene
end

return M