--[[

socket 通信接口

]]

-- 该接口是全局变量
SOCKET = {}

local socketActions = require("GameLuaScript/Network/socketActions")
local json = require("GameLuaScript/Network/dkjson")
local KNLoading = require("GameLuaScript/Common/KNLoading")


local sockets = {}

--[[

获取一个实例 ( 单例模式 )

]]
function SOCKET.getInstance( self , socket_type )
	if sockets[socket_type] == nil then
		sockets[socket_type] = self.new( socket_type )
	end

	return sockets[socket_type]
end

--[[

打开一个新的 socket

]]
function SOCKET.new( socket_type , host , port )
	local socket = {}

	host = host or CONFIG_SOCKET_HOST
	port = port or CONFIG_SOCKET_PORT

	-- 打开一个新链接
	socket = LuaSocket:getInstance()
	socket:openSocket( host , port )


	-- 错误处理
	-- todo ....
	if not socket then

	end


	--[[

	发送数据, 并获得返回的数据

	param 参数列表
		success_callback  function  成功回调
		error_callback  function  失败回调
		sync  boolean  是否异步，默认为true

	]]

	function socket:call(mod , act , command , data , param)
		local func = mod .. "_" .. act
		local success = false
		local loading = nil

		-- 数据容错
		if type(param) ~= "table" then param = {} end
		--是否存在回调 成功 函数
		if type(param.success_callback) ~= "function" then param.success_callback = function() end end
		--是否存在回调 错误 函数
		if type(param.error_callback)   ~= "function" then
			param.error_callback = function(err)
				KNMsg.getInstance():flashShow("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
			end
		end
		if type(data) ~= "table" then data = {} end


		-- 判断 socketActions 里有没有该回调
		if type(socketActions[func]) ~= "function" then
			-- 错误处理
			echoInfo("no socketActions function [" .. func .. "]")
			return false
		end

		-- 发送数据前，执行 socketActions 回调
		success , data = socketActions[func](1 , data , param.error_callback)

		-- 错误处理
		if not success then
			param.error_callback( {code = "-996" , msg = "网络请求出错."} )
			return false
		end

		-- 拼装数据
		local request_data = {
			m = mod,
			a = act,
			command = command,
			sid = DATA_Session:get("sid"),
			uid = DATA_Session:get("uid"),
			server_id = DATA_Session:get("server_id"),
			data = data,
		}


		-- 显示遮罩层
		local scene = display.getRunningScene()
		loading = KNLoading.new()
		scene:addChild( loading )

		local ssss = {
			m = "login",
			a = "develop",
			open_id = "sdfse",
		}
		print("socket 发送数据")

		-- 发送数据
		socket:sendSocket( json.encode(ssss) )
		print(json.encode(ssss))
		print("socket 发送数据结束")
		print("socket 开始接收数据")
		-- 接收数据
		local response = socket:getSocket()
		print("socket 数据接收结束")
		--返回数据中不包含response
		if not response or response == "" then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			-- 关闭链接
			socket:close(socket_type)

			-- 错误处理
			param.error_callback( {code = "-999" , msg = "网络请求出错."} )
			return false
		end


		-- 解包数据
		response = json.decode( response )
		if response == nil then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			param.error_callback( {code = "-998" , msg = "网络请求出错."} )
			return false
		end


		--[[处理 code 不为 0 的情况]]
		if response.code ~= 0 then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
			param.error_callback( {code = "-997" , msg = response.msg} )
			return false
		end


		-- 接到数据后，执行 socketActions 回调
		success , response = socketActions[func](2 , response , param.success_callback)


		-- 错误处理
		if not success then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			param.error_callback( {code = "-996" , msg = "网络请求出错."} )
			return false
		end

		-- 执行回调
		param.success_callback(response)


		if loading ~= nil then loading:remove() end 		-- 去掉 loading

		return true
	end



	--[[

	关闭 socket 链接

	]]
	function socket:close()
		-- 关闭链接
		socket:closeSocket()

		-- 删除变量
		socket = nil
		sockets[socket_type] = nil
	end



	return socket
end


return SOCKET
