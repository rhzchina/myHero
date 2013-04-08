require "GameLuaScript/Common/KNBar"
local RadioGroup = require"GameLuaScript/Common/KNRadioGroup"
InfoLayer= {
	layer,     --功能层
	optionBtn = {}, --保存按钮对象，方便操作
	chooseBtn    --当前选中的按钮项
}

--用户信息及底部控制按钮层，可以由其他场景直接添加，创建时须要提供对应的layerName并以此来设置底部按钮的选中状态
--layerName取值｛首页：home,背包:bag,酒馆:tavern，消息：msg,商城:shop,设置:setting｝
function InfoLayer:create(layerName)
	local this={}
	setmetatable(this,self)
	self.__index = self
	--首页的元素拆分开
	this.layer = display.newLayer()

	local bg = CCSprite:create("image/scene/home/Navigation_bg.png")
	bg:setAnchorPoint(ccp(0,0))
	this.layer:addChild(bg)

	local btn = require"GameLuaScript/Common/KNBtn"
	local group = RadioGroup:new()
	local buttom_array = {{"home",10},
													 {"Experience",88},
													 {"lineup",166},
													 {"Plunder",244},
													 {"roost",322},
													 {"shop",400}}

	local temp,select

	for i , v in pairs(buttom_array) do
			local function call_back()
				if v[1] ~= "charge" then
					if i == 1 then
						switchScene(v[1])
					elseif i == 2 then

					elseif i == 3 then
						HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "select_up",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene(v[1])
							end })
					elseif i == 4 then

					elseif i == 5 then
							HTTPS:send("Task" ,  {m="Task",a="map",task = "map",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene(v[1])
							end })
					elseif i == 6 then

					end

				else
					print("充值")
				end
			end
			if v[1] == "charge" then
				select = false
			else
				select = true
			end
			temp = btn:new("image/buttonUI/home/"..v[1], {"def.png","pre.png"},
					v[2],0,
					{callback = call_back, scale = true, selectable=select})

			if v[1] ~= "charge" then
				this.layer:addChild(temp:getLayer())
				if v[1] == layerName then --将对应按钮置为选中
					temp:select(true)
				end
			else
				this.layer:addChild(temp:getLayer())
			end
		end





    return this
end

function InfoLayer:getMainView()
	return self.layer
end

--切换当前的显示层
function InfoLayer:switchContentLayer(content)
end
return InfoLayer
