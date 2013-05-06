--[[
称雄
]]


collectgarbage("setpause" , 100)
collectgarbage("setstepmul" , 5000)


-- [[ 包含各种 Layer ]]
local roostLayer = require "GameScript/Scene/roost/roostLayer"
require "GameScript/Scene/common/infolayer"
require "GameScript/Scene/home/InformationBox"
require "GameScript/Scene/home/MessageHeader"


local M = {}

function M:create()
	local scene = display.newScene("roost")

	---------------插入layer---------------------
	local Layer = roostLayer:new(0,0)
	scene:addChild(Layer:getLayer())

	scene:addChild(msgLayer:create(0,804))
	scene:addChild(MHLayer:create(0,686))
	scene:addChild(InfoLayer:create("roost"):getLayer())
--	scene:addChild(BTLuaLayer())
	---------------------------------------------

	return scene
end

return M
