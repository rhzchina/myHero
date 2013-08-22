
HTTPS = {}

local httpActions = require(SRC.."Network/httpActions")
local json = require(SRC.."Network/dkjson")
local KNLoading = require(SRC.."Common/KNLoading")

function HTTPS:send(mod  , data , param)
	local func = mod
	if data[string.lower(mod)] then  --拼接回调 方法
		func = mod.."_"..data[string.lower(mod)]
	end
	local loading = nil
	local urldata = mod
	local success = false

	-- 数据容错
	if type(param) ~= "table" then param = {} end
	if type(param.success_callback) ~= "function" then param.success_callback = function() end end
	if type(param.error_callback)   ~= "function" then
		param.error_callback = function(err)
			MsgBox.create():flashShow("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
		end
	end

	-- 判断 httpActions 里有没有该回调
	if type(httpActions[func]) ~= "function" then
		-- 错误处理
		echoInfo("no httpActions function [" .. func .. "]")
		return false
	end

		-- 发送数据前，执行 httpActions 回调
	success , data = httpActions[func](1 , data , param.error_callback)

	--[[错误处理]]
	if not success then
		param.error_callback( {code = "-996" , msg = "网络请求出错"} )
		return false
	end


	--[[显示遮罩层]]
	local scene = display.getRunningScene()
		loading = KNLoading.new()
	scene:addChild( loading )


	--[[接收数据]]
	local function _callback(httpCode , response)
	if not response then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
			param.error_callback( {code = "-999" , msg = "网络请求出错."} )
			return false
		end

		--[[解包数据]]
		response = json.decode( response )

		dump(response)

		if response == nil then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
			param.error_callback( {code = "-998" , msg = "网络请求出错."} )
			return false
		end



		--[[处理 code 不为 0 的情况]]
		if  response.code and response.code ~= 0 then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
			param.error_callback( {code = "-997" , msg = response.msg} )
			return false
		end

		--[[接到数据后，执行 httpActions 回调]]
		success , response = httpActions[func](2 , response , param.success_callback)


		--[[错误处理]]
		if not success then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			param.error_callback( {code = "-996" , msg = "网络请求出错."} )
			return false
		end

		--[[执行回调]]
--		param.success_callback(response)


		if loading ~= nil then loading:remove() end 		-- 去掉 loading
	end


	-- 生成 URL-encode 之后的请求字符串
	local function http_build_query(data)
		if data.m ~= "login" then  --加入会话数据
			data.sid = DATA_Session:get("sid")
			data.uid = DATA_Session:get("uid")
			data.server_id = DATA_Session:get("server_id")			
		end
		print("data 的数据是")
		print(json.encode( data ))
		return json.encode( data )
	end

--	-- 一次http请求
	local function sendRequest(url , postdata , callback)
		local request = network.createHTTPRequest(function(event)
			local request = event.request

			local error_code = request:getErrorCode()
			if error_code ~= 0 then
				local error_msg = request:getErrorMessage()
				echoLog("HTTP" , "===== error: " .. error_code .. " , msg: " .. error_msg .. " =====" )

				if string.find(error_msg , "resolve host name") ~= nil or string.find(error_msg , "connect to server") or string.find(error_msg , "Failed sending data") then
					error_msg = "网络异常，无法连接服务器"
				elseif string.find(error_msg , "Timeout") ~= nil then
					error_msg = "网络连接超时"
				end
				callback( error_code , error_msg )
				return
			end

			callback( request:getResponseStatusCode() , request:getResponseDataLua() )
		end , url , "POST")

		-- request:setAcceptEncoding(kCCHTTPRequestAcceptEncodingDeflate)
		request:setPOSTData(postdata)

		request:start()
--		print("发送数据")
--		local http = HSHttpRequest:getInstance()
--		http:SetUrl(url)
--		http:SetRequestType(HTTP_MODE_POST)
--
--		http:SetRequestData(postdata , string.len(postdata))
--		http:SetTag("POST")
--
--		HSBaseHttp:GetInstance():Send(http);
--		http:creadFuancuan(callback)
--
--		http:release()
	end


	print("url  = ".. CONFIG_HTTP_URL..urldata)
	-- 发送数据
	sendRequest( CONFIG_HTTP_URL..urldata, http_build_query(data) , _callback)


end
