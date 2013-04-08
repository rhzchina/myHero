--英雄上阵
HLPLayer= {
	layer,  --信息头
}

function HLPLayer:new(point_x,point_y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = display.newLayer()

	local header_bg = CCSprite:create("image/scene/herolup/bg.png")
	setAnchPos(header_bg,point_x,point_y)
	this.layer:addChild(header_bg)

	local font = CCSprite:create("image/scene/herolup/font.png")
	setAnchPos(font,point_x+160,point_y+545)
	this.layer:addChild(font)


	--[[排序]]
	local btns = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local Sequence

	    Sequence = btns:new("image/buttonUI/heroup/Sequence/",{"def.png","pre.png"},point_x+5,point_x+620,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print(i,"---")
	    				 end
	    		 })

		this.layer:addChild(Sequence:getLayer())


	--[[全星及]]
	local btns = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local Star

	    Star = btns:new("image/buttonUI/heroup/Star/",{"def.png","pre.png"},point_x+383,point_x+620,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print(i,"---")
	    				 end
	    		 })

		this.layer:addChild(Star:getLayer())

	local taskinfo = require"GameLuaScript/Scene/herolup/conCard"
	local task
	local task_x = 0
	local task_y = 100
	local ksv = KNScrollView:new(0,155,480,460,0,false)
	local array_table = {}
	local num = 0
	local is_click = false
	local selec_card = nil---选中的卡牌
	for i = 1,DATA_CardAll:size() do
		task = taskinfo:new(DATA_CardAll:get(i),task_x,task_y,{parent = ksv,
																callback = function(cards)
																		num = i
																		is_click = true
																		if cards:get_true() == false then
																			cards:set_true(true)
																		end
																end})
		ksv:addChild(task:getLayer(),task)
		task_y = task_y -110
		table.insert(array_table,task)
	end
	this.layer:addChild(ksv:getLayer())


	--[[确定]]
	local btns = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local Determine

	    Determine = btns:new("image/buttonUI/heroup/Determine/",{"def.png","pre.png"},point_x+343,point_x+100,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
							if selec_card ~= nil then
									HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "up",card_id = selec_card:get_id(),index = LineUp_Index,data = send_data,sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
										switchScene("lineup")
									end })
							end
	    				 end
	    		 })


		this.layer:addChild(Determine:getLayer())


		--[[取笑]]
	local btns = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local Cancel

	    Cancel = btns:new("image/buttonUI/heroup/Cancel/",{"def.png","pre.png"},point_x+5,point_x+100,
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					switchScene("lineup")
	    				 end
	    		 })


		this.layer:addChild(Cancel:getLayer())






	function tick()

		if is_click == true then
			is_click = false
			 for i = 1 ,table.getn(array_table) do
				local this_card = array_table[i]
					if i == num then
							this_card:set_true(true)
							selec_card = this_card
					else
							this_card:set_true(false)
							selec_card = this_card
					end
			 end
			 num = 0
		end

	end

	local handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick , 0.05 , false)
	return this
end

function HLPLayer:getLayer()
	return self.layer
end

return HLPLayer
