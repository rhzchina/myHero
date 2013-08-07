--[[

http 通信接口

]]

-- 该接口是全局变量
HTTP = {}

local httpActions = require(SRC.."Network/httpActions")
local json = require(SRC.."Network/dkjson")
local KNLoading = require(SRC.."Common/KNLoading")

require(SRC.."Data/Session")


--[[

发送数据, 并获得返回的数据

param 参数列表
	success_callback  function  成功回调
	error_callback  function  失败回调
	sync  boolean  是否异步，默认为true

]]
function HTTP:call(mod , act , data , param)
	local func = mod
	local success = false
	local loading = nil


	-- 数据容错
	if type(param) ~= "table" then param = {} end
	if type(param.success_callback) ~= "function" then param.success_callback = function() end end
	if type(param.error_callback)   ~= "function" then
		param.error_callback = function(err)
			MsgBox.create:flashShow("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
		end
	end
	if type(data) ~= "table" then data = {} end


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

	-- 拼装数据
	local request_data = {
		m = mod,
		a = act,
	}

	--[[非登录模块，添加登陆态参数]]
	if mod ~= "login" then
		request_data["sid"] = DATA_Session:get("sid")
		request_data["uid"] = DATA_Session:get("uid")
		request_data["server_id"] = DATA_Session:get("server_id")
	end

	for k , v in pairs(data) do
		request_data[k] = v
	end


	--[[显示遮罩层]]
	local scene = display.getRunningScene()
	loading = KNLoading.new()
	scene:addChild( loading )




	--[[接收数据]]
	local function _callback(httpCode , response)
		--[[
		echoLog("HTTP" , "#####################")
		echoLog("HTTP" , "#####################")
		echoLog("HTTP" , "### " .. string.len(response))
		echoLog("HTTP" , "### " .. response)
		echoLog("HTTP" , "#####################")
		echoLog("HTTP" , "#####################")
		]]

		if not response then
			if loading ~= nil then loading:remove() end 		-- 去掉 loading

			--[[错误处理]]
			param.error_callback( {code = "-999" , msg = "网络请求出错."} )
			return false
		end

		--[[解包数据]]
		response = json.decode( response )

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
		if type(data) ~= "table" then return "" end

		local str = ""
		for k , v in pairs(data) do
			str = str .. k .. "=" .. string.urlencode(v) .. "&"
		end

		return str
	end

	-- 一次http请求
	local function sendRequest(url , postdata , callback)
		local http = HSHttpRequest:getInstance()
		http:SetUrl(url)
		http:SetRequestType(HTTP_MODE_POST)

		http:SetRequestData(postdata , string.len(postdata))
		http:SetTag("POST")

		HSBaseHttp:GetInstance():Send(http);
		http:creadFuancuan(callback)

		http:release()
	end



	-- 发送数据
	sendRequest( CONFIG_HTTP_URL , http_build_query(request_data) , _callback)

	return true
end


return HTTP
