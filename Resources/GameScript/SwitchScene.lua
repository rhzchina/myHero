--[[

切换场景

** Param **
	name 场景名
	temp_data 临时变量，可传递到下一个场景
	callback 回调函数

]]
function switchScene( name , temp_data , callback )
	-- 去掉所有未完成的动作
	CCDirector:sharedDirector():getActionManager():removeAllActions()

	local scene_file = "GameScript/Scene/" .. name .. "/scene"
	local scene = require(scene_file)

	-- echoLog("Scene" , "Load Scene [" .. name .. "]")
	display.replaceScene( scene:create(temp_data) )

	if type(callback) == "function" then
		callback()
	end
end