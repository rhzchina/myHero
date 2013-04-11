-- for CCLuaEngine
function __G__TRACKBACK__(errorMessage)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: "..tostring(errorMessage).."\n")
    CCLuaLog(debug.traceback("", 2))
    CCLuaLog("----------------------------------------")
end

-- 简单配置
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2
DEBUG_MEM_USAGE = 10	-- 显示内存使用

LineUp_Index = 1

xpcall(function()
	-- 设置图片质量
	CCDirector:sharedDirector():setProjection(kCCDirectorProjection2D);

	require("GameLuaScript/Config/base")	-- 配置文件
	require("GameLuaScript/Common/CommonFunction")
	-- 引入 quick 框架
	require("framework/init")
	require("framework/client/init")

	-- 游戏入口 - 后续可以去掉很多
	require("GameLuaScript/Data/Session")
	require("GameLuaScript/Network/Myhttp")
	--require("GameLuaScript/Network/socket")

	require("GameLuaScript/Common/CommonFunction")
	require("GameLuaScript/SwitchScene")

	-- 常用组件
	require("GameLuaScript/Common/KNButton")
	require("GameLuaScript/Common/KNMsg")
	require("GameLuaScript/Common/KNScrollView")


	----------------
	-- 创建登录场景
	switchScene("login")
--	switchScene("fighting")

	-- local LoginScene = require("GameLuaScript/Scene/login/scene")
	-- display.replaceScene( LoginScene:create() )
end, __G__TRACKBACK__)
