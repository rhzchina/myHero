--[[

初始化

1、判断 唯一ID是否一致，如果不一致，则需重新初始化 (删除文件夹)

]]

function __G__TRACKBACK__(errorMessage)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: "..tostring(errorMessage).."\n")
    CCLuaLog(debug.traceback("", 2))
    CCLuaLog("----------------------------------------")
end

require "GameScript/initialization/init_functions"


local interface = UpdataRes:getInstance()
local platform_type = interface:get_type()

-- SD 卡路径
IMG_PATH = ""

-- 全局变量
ERROR_MSG = ""
ERROR_CODE = 0

-- 定义全局 requires 函数
if platform_type == 2  then  --ios
    function requires(filePath , filename)
        if INIT_FUNCTION.file_exists(filePath .. filename .. ".lua") then
            return require("Library/Caches/" .. filename)
        else
            return require(filename)
        end
    end
else
    function requires(filename)
        if INIT_FUNCTION.file_exists(IMG_PATH .. filename .. ".lua") then
            return require(IMG_PATH .. filename)
        else
            return require(filename)
        end
    end
end



-- Begin
xpcall(function()
    require("GameScript/Config/channel")

	-- 设置SD卡路径
	if platform_type == 0 then 					-- windows
		IMG_PATH = ""
	elseif platform_type == 1 then 				-- Android
		IMG_PATH = "/mnt/sdcard/suitangtianxia_" .. CHANNEL_ID .. "/"
	elseif platform_type == 2 then 				-- IOS
		IMG_PATH = CCFileUtils:sharedFileUtils():getWriteablePath()
	end

--	if platform_type == 0 then					-- windows 直接进入游戏
--		requires( "GameLuaScript/GameCanvasLua")
--		return
--	end

	-- 非 windows 平台，则要走以下逻辑 (初始化 && 在线升级)
    local scene = require "GameScript/initialization/init_scene"
    CCDirector:sharedDirector():runWithScene(scene:create())
end , __G__TRACKBACK__)