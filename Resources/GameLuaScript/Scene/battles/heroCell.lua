--[[

卡牌类

]]

local M = {}
local heros = {}

local hpBar = require("GameLuaScript/Common/KNBar")


--[[获取对象]]
function M:get( group , index )
	if heros[group] == nil or heros[group][index] == nil then return nil end

	return heros[group][index]
end


--[[数据初始化 清空所有数据]]
function M:init( first )
	if first then heros = {} end

	local temp_heros = {}
	for i = 1 , 2 do			-- 两方
		temp_heros[i] = {}
		for j = 0 , 3 do		-- 上阵4人
			if heros[i] ~= nil and heros[i][j] ~= nil then
				heros[i][j]:removeFromParentAndCleanup(true)
				heros[i][j] = nil
			end

			temp_heros[i][j] = nil
		end
	end

	heros = temp_heros
end


--[[清空单个数据]]
function M:clear( group , index )
	heros[group][index]:removeFromParentAndCleanup(true)
	heros[group][index] = nil
	return true
end


--[[生成对象]]
function M.new( data , param )
	if type(param) ~= "table" then param = {} end

	-- 容器
	local hero = display.newLayer()
	-- local hero = CCLayerColor:create( ccc4(255 , 255 , 255 , 100) )


	-- 英雄的数据
	local _data = data
	hero_group = _data["_group"]
	hero_index = _data["_index"]


	-- 英雄背景图片
	local bgColorFrame = display.newSprite("image/hero/frame01.png")
	display.align(bgColorFrame , display.LEFT_BOTTOM , 0 , 0)
	hero:addChild(bgColorFrame)

	-- 获取大小
	local frameSize = bgColorFrame:getContentSize()
	hero:setContentSize( CCSize(frameSize.width , frameSize.height ) )


	-- 英雄图片
	local heroImage
	if data.type == "npc" then--怪物
		heroImage = display.newSprite("image/npc/" .. data.type .. data.npc_id .. ".png")
	else
		heroImage = display.newSprite("image/hero/" .. data.type .. data.gindex .. ".png")
	end
	display.align(heroImage , display.LEFT_BOTTOM , 8 , 31)
	-- heroImage:setPosition( 0 , 10 )
	hero:addChild(heroImage)


	-- 血条
	local hp_bar = hpBar:new("hp1" , 0 , 0 , { curValue = data.hp , maxValue = data.org_hp , textSize = 18 } )
	-- hp_bar:setPosition( -47 , -44 )
	display.align(hp_bar , display.LEFT_BOTTOM , 8 , 30)
	hero:addChild(hp_bar)


	-- 点击区域记录
	local rect = CCRectMake(0 , 0 , frameSize.width , frameSize.height)

	--[[------------ 对外接口 ------------]]
	--[[重置 setPosition 接口]]
	local old_setPosition = hero.setPosition
	function hero:setPosition(x , y)
		rect = CCRectMake(x , y , frameSize.width , frameSize.height)
		-- rect:setPosition(x , y)
		old_setPosition(hero , x , y)
	end

	--[[获取卡牌的位置和尺寸]]
	function hero:getPositionAndSize()
		local hero_x , hero_y = hero:getPosition()
		-- local hero_size = hero:getContentSize()
		local hero_width = frameSize.width
		local hero_height = frameSize.height

		return {
			_x = hero_x,
			_y = hero_y,
			_cx = hero_x + hero_width / 2,
			_cy = hero_y + hero_height / 2,
			_width = hero_width,
			_height = hero_height,
		}
	end

	--[[设置英雄数据]]
	function hero:setData( key , value )
		_data[key] = value
	end

	--[[获取英雄数据]]
	function hero:getData( key )
		if key ~= nil then return _data[key] end

		return _data
	end

	--[[刷新英雄卡牌血量]]
	function hero:refreshViewHp()
		hp_bar:setCurValue( _data["hp"] , false )
	end


	-- 存储数据
	if heros[hero_group] == nil then heros[hero_group] = {} end
	heros[hero_group][hero_index] = hero


	-- 点击事件
	local function onTouch(eventType , x , y)
	    if eventType == CCTOUCHBEGAN then
	    	-- 判断是否点中了这张卡牌
	    	if rect:containsPoint( ccp(x , y) ) then
	    		return true
	    	else
	    		return false
	    	end
	    end
	    if eventType == CCTOUCHMOVED then return true end

	    if eventType == CCTOUCHENDED then
	    	-- 点击回调函数
	    	if param.click then param.click(_data) end
			-- echoInfo("click hero " .. _data["name"])
	        return true
	    end

	    return false
	end

	heros[hero_group][hero_index]:setTouchEnabled( true )
	heros[hero_group][hero_index]:registerScriptTouchHandler(onTouch)

	return heros[hero_group][hero_index]
end


return M