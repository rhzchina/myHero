--卡牌信息
local battleLayer = {layer,is_select_card,is_click_over,is_select_star}

local linefo = require "GameScript/Scene/battlere/battleCardInfo"
function battleLayer:new(point_x,point_y,params)
	local this={}
	setmetatable(this,self)
	self.__index = self
	this.is_select_card = false
	this.is_click_over = false
	this.is_select_star = false
	this.layer = CCLayer:create()

	local bg = CCSprite:create("image/scene/battle/bg.png")
	setAnchPos(bg,0,80)
	this.layer:addChild(bg)

	local card_array = {{5,470,1},{162,470,2},{320,470,3},{5,240,4},{162,240,5},{320,240,6}}
	
	local star_point,end_point = 1,1
	local temp_card = nil
	local temp_card1 = nil
	local card = nil
	local card_array_obj = {}

	 local card = nil

	 for i,v in pairs(card_array) do
		if i <= DATA_FrontRow:size() then
			if  _G.next (DATA_FrontRow:get(i) )  ~= nil then
				v[3] = DATA_FrontRow:get(i)["card_id"]
				card =linefo:new(DATA_FrontRow:get(i)["card_id"] ,v[1],v[2],{
																callback = function(card_this,point_x,point_y)
																				if(card_this:get_click() == true) then
																					card_this:set_click(false)
																					if card_this:get_Transposition() == true then
																						this.is_select_card = true
																						temp_card1 = card_this
																						end_point = i
																					elseif this.is_select_star == false then
																						this.is_select_star = true
																						star_point = i
																						temp_card = card_this
																					end
																				end

																		if i == table.getn(card_array_obj)  then
																				this.is_click_over = true

																		end
																end}
													 )
				this.layer:addChild(card:getLayer())
				table.insert(card_array_obj,card)
				dump(v[3])
			end
		end
	 end


	--返回按钮按钮
	--local group = RadioGroup:new()
	local temps

	    temps = Btn:new(IMG_BTN,{"btn_bg.png","btn_bg_press.png"},20,125,
	    		{
	    			front = IMG_TEXT.."back.png",
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					--HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "select_up",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene("lineup")
							--end })
	    				 end
	    		 })

		this.layer:addChild(temps:getLayer())

	--保存
	--local group = RadioGroup:new()
	local temps

	    temps = Btn:new(IMG_BTN,{"btn_bg.png","btn_bg_press.png"},255,125,
	    		{
	    			front = IMG_TEXT.."save.png",
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
								 local send_data = {}
								 for i,v in pairs(card_array) do
										if i <= DATA_FrontRow:size() then
											if  _G.next (DATA_FrontRow:get(i) )  ~= nil then
												send_data[i] = v[3]
											end
										end
								end
								HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "Replace",data = send_data,sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene("lineup")
							end })
	    				 end
	    		 })

		this.layer:addChild(temps:getLayer())

	--定时器
	function tick()
		if this.is_select_star == true and  this.is_select_card == false and this.is_click_over == true then
			 this.is_click_over  = false
			--所有卡牌标识设置为false
				local card_size = table.getn(card_array_obj)
				for cs = 1, card_size do
					if card_array_obj[cs]:get_select() == true then

					else

							card_array_obj[cs]:set_Transposition(true)
					end

				end

		elseif this.is_select_card == true and this.is_click_over == true then
			this.is_select_card = false
			this.is_click_over = false
			this.is_select_star = false
			--所有卡牌标识设置为false
				local card_size = table.getn(card_array_obj)
				for cs = 1, card_size do
					card_array_obj[cs]:set_select(false)
					card_array_obj[cs]:set_Transposition(false)
				end

				--卡牌替换位置
				local point_array = card_array[star_point]
				local point_array1 = card_array[end_point]


				temp_card:set_point(card_array[end_point])
				temp_card1:set_point(card_array[star_point])

				card_array[star_point] = point_array1
				card_array[end_point] = point_array

				point_array = nil
				point_array1 = nil

				--[[card_array_obj[end_point] = temp_card
				card_array_obj[star_point] = temp_card1

				temp_card = nil
				temp_card1 = nil

				]]

		else
			this.is_click_over = false
		end
	end

	local handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick , 0.05 , false)

	return this
end

function battleLayer:getLayer()
	return self.layer
end

return battleLayer
