HomeLayer= {
	strengthItemLayer,   --强化按钮所在层，控制强化的子项是否显示
	optionBtn = {}
}
local RadioGroup = require"GameLuaScript/Common/KNRadioGroup"
function HomeLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = display.newLayer()
	local bg = CCSprite:create("image/scene/home/main.png")
	bg:setAnchorPoint(ccp(0,0))
	layer:addChild(bg)
	layer:setPosition(ccp(x,y))


	--[[其他功能按钮，阵容，行囊，融合，强化，英雄，历练]]

	local main_bt = {{"image/buttonUI/home/other/LineUP/lineup.png","lineup",20,400},
										  {"image/buttonUI/home/other/Luggage/luggage.png","Luggage",20,300},
										  {"image/buttonUI/home/other/Merge/Merge.png","Merge",20,200},
										  {"image/buttonUI/home/other/Strengthen/Strengthen.png","Strengthen",255,400},
										  {"image/buttonUI/home/other/Hero/Hero.png","Hero",255,300},
										  {"image/buttonUI/home/other/experience/Experience.png","Experience",255,200}}

	local btn = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local temp
	for i ,v in pairs(main_bt) do
	    temp = btn:new("image/buttonUI/home/button/",{"def.png","pre.png"},v[3],v[4],
	    		{
	    			front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					if i == 1 then
								HTTPS:send("Battle" ,  {m="Battle",a="LineUp",Battle = "select_up",sid = DATA_Session:get("sid"),uid = DATA_Session:get("uid"),server_id = DATA_Session:get("server_id")} ,{success_callback = function()
								switchScene("lineup")
							end })
							end
	    				 end
	    		 }, group)
	    if i == 1 then
	    	--group:chooseBtn(temp)
	    end
		layer:addChild(temp:getLayer())
	end

	local main_small = {{"Luggage/","Luggage",20,100},
										  {"Experience/","Experience",110,100},
										  {"Travel/","Travel",200,100},
										  {"Conquer/","Conquer",290,100},
										  {"Strengthen/","Strengthen",380,100}}

	local btns = require"GameLuaScript/Common/KNBtn"
	--local group = RadioGroup:new()
	local temps

	for i ,v in pairs(main_small) do
	    temps = btns:new("image/buttonUI/home/tow/"..v[1],{"def.png","pre.png"},v[3],v[4],
	    		{
	    			--front = v[1],
	    			highLight = true,
	    			scale = true,
					--selectable = true,
	    			callback=
	    				function()
	    					print(i,"---")
	    				 end
	    		 }, group)
	    if i == 1 then
	    	--group:chooseBtn(temps)
	    end
		layer:addChild(temps:getLayer())
	end

    return layer
end
