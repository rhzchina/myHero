INIT_FUNCTION = {}


local winSize = CCDirector:sharedDirector():getWinSize()
INIT_FUNCTION.width              = winSize.width
INIT_FUNCTION.height             = winSize.height
INIT_FUNCTION.cx                 = winSize.width / 2
INIT_FUNCTION.cy                 = winSize.height / 2

--[[--

Checks whether a file exists.

@param string path
@return boolean

]]
function INIT_FUNCTION.file_exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

--[[--

Reads entire file into a string, or return FALSE on failure.

@param string path
@return string

]]
function INIT_FUNCTION.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end


--[[

切换场景

** Param **
	name 场景名
	temp_data 临时变量，可传递到下一个场景
]]
function INIT_FUNCTION.switchScene( name , temp_data )
	-- 去掉所有未完成的动作
	CCDirector:sharedDirector():getActionManager():removeAllActions()

	local scene_file = "GameScript/Scene/" .. name .. "/scene"

	local scene = requires( scene_file)

	display.replaceScene( scene:create(temp_data) )
end


--设置锚点与位置,x,y默认为0，锚点默认为0
function INIT_FUNCTION.setAnchPos(node,x,y,anX,anY)
    local posX , posY , aX , aY = x or 0 , y or 0 , anX or 0 , anY or 0
    node:setAnchorPoint(ccp(aX,aY))
    node:setPosition(ccp(posX,posY))
end


--[[--

Split a string by string.

@param string str
@param string delimiter
@return table

]]
function INIT_FUNCTION.split(str, delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(str, delimiter, pos, true) end do
        table.insert(arr, string.sub(str, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(str, pos))
    return arr
end


-- http get
function INIT_FUNCTION:httpGet(url , _callback , params)
	params = params or {}
	local timeout = params.timeout or 1500
	
    local function createHTTPRequest(callback, url, method)
        if not method then method = "GET" end
        if string.upper(tostring(method)) == "GET" then
            method = kCCHTTPRequestMethodGET
        else
            method = kCCHTTPRequestMethodPOST
        end
		CCLuaLog("===== =====" )
		CCLuaLog(url)
		CCLuaLog("===== =====" )
        return CCHTTPRequest:createWithUrlLua(callback, url, method)
    end

    local function sendRequest(url , callback)
        local request = createHTTPRequest(function(event)
        	if event.name == "progress" then
        		if params.progress_callback then
					params.progress_callback(event.total , event.now)
				end
				return
			end

			if event.name == "timeout" then
        		CCLuaLog("===== error: timeout " .. timeout .. "s =====" )
        		callback( -28 , "网络请求超时" )
				return
			end

            local request = event.request

            local error_code = request:getErrorCode()
            if error_code ~= 0 then
                CCLuaLog("===== error: " .. error_code .. " , msg: " .. request:getErrorMessage() .. " =====" )
                callback( error_code , request:getErrorMessage() )
                return
            end
			
            callback( 0 , request:getResponseDataLua() )
        end , url , "GET")
		
        -- request:setAcceptEncoding(kCCHTTPRequestAcceptEncodingDeflate)
        request:setTimeout(timeout)
        request:start()
    end

    sendRequest( url , _callback)
end


-- http post
function INIT_FUNCTION:httpPost(url , request_data , _callback , params)
	params = params or {}
	local timeout = params.timeout or 30
	
    local function http_build_query(data)
        if type(data) ~= "table" then return "" end

        local str = ""
        
        for k , v in pairs(data) do
            str = str .. k .. "=" .. v .. "&"
        end

        return str
    end

    local function createHTTPRequest(callback, url, method)
        if not method then method = "GET" end
        if string.upper(tostring(method)) == "GET" then
            method = kCCHTTPRequestMethodGET
        else
            method = kCCHTTPRequestMethodPOST
        end
        return CCHTTPRequest:createWithUrlLua(callback, url, method)
    end

    local function sendRequest(url , postdata , callback)
        local request = createHTTPRequest(function(event)
			if event.name == "progress" then
				if params.progress_callback then
					params.progress_callback(event.total , event.now)
				end
				return
			end

			if event.name == "timeout" then
        		CCLuaLog("===== error: timeout " .. timeout .. "s =====" )
        		callback( -28 , "网络请求超时" )
				return
			end
			
            local request = event.request

            local error_code = request:getErrorCode()
            if error_code ~= 0 then
                CCLuaLog("===== error: " .. error_code .. " , msg: " .. request:getErrorMessage() .. " =====" )
                callback( error_code , request:getErrorMessage() )
                return
            end
			 
            callback( 0 , request:getResponseDataLua() )
        end , url , "POST")

        -- request:setAcceptEncoding(kCCHTTPRequestAcceptEncodingDeflate)
        request:setPOSTData(postdata)
        request:setTimeout(timeout)
        request:start()
    end


    sendRequest( url , http_build_query(request_data) , _callback)
end

function refreshCopy(percent)
	local action 
	action = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(function()
		local curScene = CCDirector:sharedDirector():getRunningScene()
		if _G.next(INIT_FUNCTION) == nil then
			return
		end
		if INIT_FUNCTION.layer then
--			front = layer:getChildByTag(255)
			INIT_FUNCTION.front:setPercentage(percent or 0)
			INIT_FUNCTION.label:setString(percent.."%")
			if percent >= 100 then
				if INIT_FUNCTION.update then
					curScene:removeChild(INIT_FUNCTION.layer, true)
					INIT_FUNCTION.update:checkUpdate()
				end
			end
		else
			INIT_FUNCTION.layer = CCLayer:create()
--			layer:setTag(888)
			
			local bg = CCSprite:create("images/scene/updata/bar_1.png")
			bg:setPosition(ccp(240, 120))
			INIT_FUNCTION.layer:addChild(bg)
			INIT_FUNCTION.label = CCLabelTTF:create((percent or 0).."%", "Arial", 24)
			INIT_FUNCTION.label:setPosition(ccp(240, 138))
			INIT_FUNCTION.label:setAnchorPoint(ccp(0.5, 1))
           
--			INIT_FUNCTION.label:setColor(ccc3(0x2c, 0, 0))
			INIT_FUNCTION.layer:addChild(INIT_FUNCTION.label, 1)
			INIT_FUNCTION.front = CCProgressTimer:create(CCSprite:create("images/scene/updata/bar_0.png"))
			INIT_FUNCTION.front:setTag(255)
			INIT_FUNCTION.front:setPosition(ccp(240, 120))
			
			INIT_FUNCTION.front:setType(kCCProgressTimerTypeBar)
			INIT_FUNCTION.front:setMidpoint(CCPointMake(0 , 0))--设置进度方向 (0-100)
			INIT_FUNCTION.front:setAnchorPoint(ccp(0.5 , 0.5)) --设置锚点
			INIT_FUNCTION.front:setBarChangeRate(CCPointMake(1, 0)) --动画效果值(0或1)
			INIT_FUNCTION.front:setPercentage(percent or 0) --动画效果值(0或1)
			
			INIT_FUNCTION.layer:addChild(INIT_FUNCTION.front)
			curScene:addChild(INIT_FUNCTION.layer)
		end
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(action)
	end, 0, false)


	
end

