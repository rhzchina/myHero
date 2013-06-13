-- for CCLuaEngine
function __G__TRACKBACK__(errorMessage)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: "..tostring(errorMessage).."\n")
    CCLuaLog(debug.traceback("", 2))
    CCLuaLog("----------------------------------------")
end

-- 简单配置
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info

DEBUG = 0
DEBUG_MEM_USAGE = 10	-- 显示内存使用

LineUp_Index = 1

--脚本文件目录
SRC = "GameScript/"

xpcall(function()
	-- 设置图片质量
	CCDirector:sharedDirector():setProjection(kCCDirectorProjection2D)

	require(SRC.."Config/base")	-- 配置文件
	require(SRC.."Common/CommonFunction")
	-- 引入 quick 框架
	require("framework/init")
	require("framework/client/init")

	require(SRC.."Data/Session")
	require(SRC.."Network/https")

	-- 游戏入口 - 后续可以去掉很多
	require(SRC.."SwitchScene")

	-- 常用组件
	Btn = require(SRC.."Common/LuaBtn")
	ScrollView = require(SRC.."Common/LuaScrollView")
	RadioGroup = require(SRC.."Common/LuaRadioGroup")
	CheckBox = require(SRC.."Common/LuaCheckBox")
	Mask = require(SRC.."Common/LuaMask")
	Progress = require(SRC.."Common/LuaProgress")
	Label = require(SRC.."Common/LuaLabel")
	require(SRC.."Common/LuaMsgBox")

	switchScene("login")

end, __G__TRACKBACK__)
