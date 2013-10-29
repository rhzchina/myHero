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
IS_UPDATA = false
STEPS = "1"
--脚本文件目录
SRC = IMG_PATH.."GameScript/"
xpcall(function()
	-- 设置图片质量
	CCLuaLog("on the game")
	CCDirector:sharedDirector():setProjection(kCCDirectorProjection2D)
	requires(SRC.."thread")--跑时间恢复的定时器
	requires(SRC.."Config/base")	-- 配置文件
	requires(SRC.."Config/SkillConfig")	-- 配置文件
	requires(SRC.."Config/HeroConfig")	-- 配置文件
	requires(SRC.."Config/ArmConfig")	-- 配置文件
	requires(SRC.."Config/ArmourConfig")	-- 配置文件
	requires(SRC.."Config/OrnamentConfig")	-- 配置文件
	requires(SRC.."Config/SHurdleConfig")
	requires(SRC.."Config/BHurdleConfig")
	requires(SRC.."Config/MonConfig")
	
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
	Dialog = requires(SRC.."Common/LuaDialog")
	requires( SRC.."Common/FileManager")
	requires( SRC.."Common/ShowDialog")
	requires( SRC.."Common/Guide")
	InfoLayer = requires(SRC.."Scene/common/infolayer")
	switchScene("login")
	
end, __G__TRACKBACK__)
