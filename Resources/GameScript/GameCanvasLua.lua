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
GONGGAO = 0
--脚本文件目录
SRC = "GameScript/"

xpcall(function()
	-- 设置图片质量
	CCLuaLog("on the game")
	CCDirector:sharedDirector():setProjection(kCCDirectorProjection2D)

	requires(SRC.."Config/base")	-- 配置文件
	requires(SRC.."Config/SkillConfig")	-- 配置文件
	requires(SRC.."Common/CommonFunction")
	-- 引入 quick 框架
	requires("framework/init")
	requires("framework/client/init")

	requires(SRC.."Data/Session")
	requires(SRC.."Network/https")
	requires(SRC.."Network/socket")

	-- 游戏入口 - 后续可以去掉很多
	requires(SRC.."SwitchScene")

	-- 常用组件
	Btn = requires(SRC.."Common/LuaBtn")
	ScrollView = requires(SRC.."Common/LuaScrollView")
	RadioGroup = requires(SRC.."Common/LuaRadioGroup")
	CheckBox = requires(SRC.."Common/LuaCheckBox")
	Mask = requires(SRC.."Common/LuaMask")
	Progress = requires(SRC.."Common/LuaProgress")
	Label = requires(SRC.."Common/LuaLabel")
	requires(SRC.."Common/LuaMsgBox")
	requires( SRC.."Common/FileManager")
	switchScene("login")

end, __G__TRACKBACK__)
