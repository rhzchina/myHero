--[[

幻兽

]]




local M = {}

local bird = require( "GameLuaScript/Scene/battle/petCell" )

function M:create( data )
	local layer = display.newLayer()
	dump(data)
	-- 在这个layer，根据data来显示幻兽
	local selfBird = bird:create( data[1] )
	selfBird:setPosition( 97 , 104 )
	layer:addChild(selfBird)
	
	
	--敌方幻兽
	local foeBird = bird:create(nil)
	foeBird:setPosition( 370 , 750 )
	foeBird:setDisabled()	--禁用操作
	layer:addChild(foeBird)
--	
    return layer
end

return M
