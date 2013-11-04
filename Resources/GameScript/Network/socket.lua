----[[
--
--socket 通信接口
--
--]]
--
---- 该接口是全局变量
--SOCKET = {}
--
--local socketActions = requires(SRC.."Network/socketActions")--requires("GameLuaScript/Network/socketActions")
----local commonActions = requires(SRC.."Network/commonActions")--requires("GameLuaScript/Network/commonActions")
local json = requires(SRC.."Network/dkjson")-- requires("GameLuaScript/Network/dkjson")

local KNLoading = requires(SRC.."Common/KNLoading")
--local KNLoading = requires(SRC.."Common/KNLoading")--requires("GameLuaScript/Common/KNLoading")
--
--
--local sockets = {}
--
----[[
--
--获取一个实例 ( 单例模式 )
--
--]]
--function SOCKET.getInstance( self , socket_type )
--	if sockets[socket_type] == nil then
--		sockets[socket_type] = self.new( socket_type )
--	end
--
--	return sockets[socket_type]
--end
--
--function SOCKET.delInstance( self , socket_type )
--	if sockets[socket_type] ~= nil then
--		sockets[socket_type] = nil
--	end
--end
--
----[[
--
--打开一个新的 socket
--
--]]
--function SOCKET.new( socket_type , host , port )
--	local socket = {}
--
--	host = host or CONFIG_SOCKET_HOST
--	port = port or CONFIG_SOCKET_PORT
--
--	-- 打开一个新链接
--	local has_login = false
--
--	socket = LuaSocket:getInstance()
--	local opensocket_ret = socket:openSocket( host , port )
--
--
--	-- 错误处理
--	-- todo ....
--	if not socket then
--
--	end
--
--	-- 回调队列
--	local callbacks_table = {}
--
--	local loading = nil
--
--	function socket:call(mod , act , command , data , param)
--		if opensocket_ret < 0 then
--			SOCKET:delInstance(socket_type)
--			Dialog.tip("网络出现异常，你可能已经断网了")
--			return
--		end
--
--		-- 判断是否第一次连服务器
--		if not has_login and command ~= "open" then
--			-- 尝试连接长连接服务器
--			SOCKET:getInstance(socket_type):call("log" , "in" , "open" , {} , {
--				success_callback = function()
--					has_login = true
--					-- 连接成功后，再回调
--					SOCKET:getInstance(socket_type):call(mod , act , command , data , param)
--				end
--			})
--			return
--		end
--
--
--
--		local func = mod .. "_" .. act
--		local success = false
--
--		-- 数据容错
--		if type(param) ~= "table" then param = {} end
--		--是否存在回调 成功 函数
--		if type(param.success_callback) ~= "function" then param.success_callback = function() end end
--		--是否存在回调 错误 函数
--		if type(param.error_callback)   ~= "function" then
--			param.error_callback = function(err)
--				Dialog.tip("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
--			end
--		end
--		if type(data) ~= "table" then data = {} end
--
--
--		-- 判断 socketActions 里有没有该回调
--		if type(socketActions[func]) ~= "function" then
--			-- 错误处理
--			echoInfo("no socketActions function [" .. func .. "]")
--			return false
--		end
--
--		-- 发送数据前，执行 socketActions 回调
--		success , data = socketActions[func](1 , data , param.error_callback)
--
--		-- 错误处理
--		if not success then
--			param.error_callback( {code = "-1996" , msg = "网络请求出错."} )
--			return false
--		end
--
--		-- 拼装数据
--		local request_data = {
--			name = DATA_User:get("name"),
--			hostIp = DATA_Session:get("uid"),
--			type = "open"		
--		}
--
--
--		-- 显示遮罩层
--		local scene = display.getRunningScene()
--		loading = KNLoading.new()
--		scene:addChild( loading )
--
--		-- 客户端主动发送数据的用自定义的回调函数接数据
--		callbacks_table[func] = function(code , response)
--			--返回数据中不包含response
--			if not response or response == "" then
--				if loading ~= nil then loading:remove() end 		-- 去掉 loading
--
--				-- 关闭链接
--				 socket:close(socket_type)
--
--				-- 错误处理
--				param.error_callback( {code = "-1999" , msg = "网络请求出错."} )
--				return false
--			end
--
--			response = json.decode( response )
--			if response == nil then
--				if loading ~= nil then loading:remove() end 		-- 去掉 loading
--
--				param.error_callback( {code = "-1998" , msg = "网络请求出错."} )
--				return false
--			end
--
--			success , response = socketActions[func](2 , response , param.success_callback)
--
--
--			-- 错误处理
--			if not success then
--				if loading ~= nil then loading:remove() end 		-- 去掉 loading
--
--				param.error_callback( {code = "-1996" , msg = "网络请求出错."} )
--				return false
--			end
--
--			if loading ~= nil then loading:remove() end 		-- 去掉 loading
--			
--			if command == "open" then
--				has_login = true
--			end
--		end
--
--
--		-- 一次socket请求
--		local function sendRequest(postdata , callback)
--			echoLog("SOCKET" , postdata)
--			print("发送的数据是"..postdata)
--			-- socket:creadFuancuan(callback)
--			socket:sendSocket( postdata.."\n" )
--		end
--
--
--		-- 发送数据
----		sendRequest(DATA_User:get("name").."@"..DATA_Session:get("uid").."@".."open\n")		
--		sendRequest( json.encode(request_data))
--
--
--		return true
--	end
--
--	--[[
--
--	关闭 socket 链接
--
--	]]
--	function socket:close()
--		-- 关闭链接
--		socket:closeSocket()
--
--		-- 删除变量
--		socket = nil
--		sockets[socket_type] = nil
--	end
--
--
--
--
--
--
--	--[[统一回调]]
--	local function _callback(code , response)
--		if code < 0 then
--			echoLog("SOCKET" , "Bad Code : " .. code)
--			if loading ~= nil then loading:remove() end 		-- 去掉 loading
--
--			if code == -100 or code == -101 then
--				-- 删掉对象
--				SOCKET:delInstance(socket_type)
--				local cur_scene = display.getRunningScene()
--
--				if cur_scene["name"] == "battle" then
--					MsgBox.create():boxShow("网络出现异常，你可能已经断网了" , {
--						confirmFun = function()
--							switchScene("login")
--						end
--					})
--				else
--					Dialog.tip("网络出现异常，你可能已经断网了")
--				end
--			elseif code == -99 then
--				print("kick_off  ========")
--				-- 解包，先截取前面30个字符
--				local response_func = string.sub(response , 0 , 30)
--				response_func = string.trim(response_func)
--
--				-- 后面是 json 串
--				response = string.sub(response , 31)
--				
--				--[[服务端推送数据的，在下面处理]]
--				-- 解包数据
--				response = json.decode( response )
--
--				KNMsg.getInstance():boxShow(response.msg , {
--					confirmFun = function()
--						SOCKET:delInstance( "battle" )
--						switchScene("login")
--					end
--				})
--			end
--
--			return false
--		end
--		
--		--返回数据中不包含response
--		if not response or response == "" or string.len(response) <= 30 then
--			if loading ~= nil then loading:remove() end 		-- 去掉 loading
--
--			-- 关闭链接
--			 socket:close(socket_type)
--
--			-- 错误处理
--			param.error_callback( {code = "-1999" , msg = "网络请求出错."} )
--			return false
--		end
--
--		--[[客户端主动发送数据的用自定义的回调函数接数据]]
--		if callbacks_table[response_func] ~= nil then
--			return callbacks_table[response_func](code , response)
--		end
--
--		
--		--[[服务端推送数据的，在下面处理]]
--		-- 解包数据
--		response = json.decode( response )
--		if response == nil
----			  or response.code ~= 0 or socketActions[response_func] == nil 
--		 then
--			echoLog("SOCKET" , "Bad Data")
--			return false
--		end
--
--
--		-- 接到数据后，执行 socketActions 回调
----		commonActions.saveCommonData( response )
--		socketActions["log_in"](2 , response)
--	end
--
--
--	-- 创建统一回调
--	socket:creadFuancuan(_callback)
--
--
--
--	return socket
--end
--
--
--return SOCKET
SOCKET = {
}

local socket
local loading

function SOCKET:init()
	if not socket then
		local host =  CONFIG_SOCKET_HOST
		local port =  CONFIG_SOCKET_PORT
	
		socket = LuaSocket:getInstance()
		local opensocket_ret = socket:openSocket( host , port, HOST_TYPE )
		
		socket:creadFuancuan(SOCKET.callback)
	end
end

function SOCKET:callback(response)
	local result = json.decode(response)
	if not result then
		Dialog.tip("数据格式错误 ")
		return
	end
	dump(result)
	if result.mode == "open" then
		DATA_Chat:set(result)
		if tonumber(DATA_User:get("role")) == 0 then
			switchScene("createRole")
		else
			switchScene("home")
		end
		
	elseif result.mode == "tall" then
		DATA_Chat:addMsg("tall", result.add)
		
		local scene = display.getRunningScene()
		if scene.name == "chat" then
			scene:removeChild(loading, true)
			scene:refresh()
		end
	elseif result.mode == "system" then
		DATA_Chat:addMsg("system", result.add)
		local scene = display.getRunningScene()
		if scene.name == "system" then
			scene:removeChild(loading, true)
			scene:refresh()
		end
	elseif result.mode == "pay" then
		local gold = result.add
		DATA_User:setkey("Gold", gold["Gold"])
		IS_UPDATA = true
		local scene = display.getRunningScene()
		if scene.name == "system" then
			scene:removeChild(loading, true)
			scene:refresh()
		end
	elseif result.mode == "error" then
		Dialog.tip(result["add"]["content"])
		local scene = display.getRunningScene()
		if scene.name == "chat" then
			scene:removeChild(loading, true)
			scene:refresh()
		end
	elseif result.mode == "prop" then
		Dialog.tip("获得一个礼包")
		DATA_Bag:setByKey("prop", result["add"]["prop"]["cid"], result["add"]["prop"])
	end
	
end

function SOCKET:call(command, params)

	SOCKET:init()
	
	local request_data = {
		name = DATA_CommonUser:get_user().user_name,
		hostIp = DATA_CommonUser:get_user().uid,
		type = command 
	}
	params = params or {}
	for k, v in pairs(params) do
		request_data[k] = v
	end
	
	local scene = display.getRunningScene()
	loading = KNLoading.new()
	scene:addChild( loading )
		
	SOCKET:sendRequest( json.encode(request_data))
end


--	 一次socket请求
function SOCKET:sendRequest(postdata , callback)
	echoLog("SOCKET" , postdata)
	print("发送的数据是"..postdata)
	socket:sendSocket( postdata.."\n" )
end
 