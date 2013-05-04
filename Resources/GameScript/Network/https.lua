
HTTPS = {}

local httpActions = require("GameScript/Network/httpActions")
local json = require("GameScript/Network/dkjson")
local KNLoading = require("GameScript/Common/KNLoading")

function HTTPS:send(mod  , data , param)
	local func = mod--设置为回调函数字段
	local loading = nil
	local urldata = mod
	local success = false

	-- 数据容错
	if type(param) ~= "table" then param = {} end
	if type(param.success_callback) ~= "function" then param.success_callback = function() end end
	if type(param.error_callback)   ~= "function" then
		param.error_callback = function(err)
			KNMsg.getInstance():flashShow("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
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

--		dump(response)

		if response == nil then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
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

		--[[接到数据后，执行 httpActions 回调]]
		success , response = httpActions[func](2 , response , param.success_callback)


		--[[错误处理]]
		if not success then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			param.error_callback( {code = "-996" , msg = "网络请求出错."} )
			return false
		end

		--[[执行回调]]
		param.success_callback(response)


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

	-- 一次http请求
	local function sendRequest(url , postdata , callback)
		print("发送数据")
		local http = HSHttpRequest:getInstance()
		http:SetUrl(url)
		http:SetRequestType(HTTP_MODE_POST)

		http:SetRequestData(postdata , string.len(postdata))
		http:SetTag("POST")

		HSBaseHttp:GetInstance():Send(http);
		http:creadFuancuan(callback)

		http:release()
	end


	print("url  = ".. CONFIG_HTTP_URL..urldata)
	-- 发送数据
	sendRequest( CONFIG_HTTP_URL..urldata, http_build_query(data) , _callback)


end
