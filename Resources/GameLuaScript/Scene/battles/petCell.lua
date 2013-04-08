--[[

	单个幻兽

]]--

local logic = require("GameLuaScript/Scene/battle/logicLayer")

local M = {}

function M:create( data )
	local isDisabled = false	--是否禁用操作
	if type( data ) ~="table" then
		data = {
			id = 250 ,
			cd = 2 ,
			name = "朱雀" ,
			type = "recover",
			num = 100 ,
			time = "122222222",
		}
	end
	
	local content = display.newLayer()
	
	
	local actionLayer = display.newLayer()
	
	local imagePath = IMAGEPATH .. "/pet/"
	--背景
	local bg = display.newSprite( imagePath .. "light.png" )
	actionLayer:addChild( bg )
	
	--幻兽背景效果
	local function petEffect()
		local action1 = transition.fadeIn( bg , {time = 1 } )  
		local action2 = transition.fadeOut( bg , {time = 1 } )  
		bg:runAction(transition.sequence({action1 , action2 , CCCallFunc:create(petEffect)}))  
	end
	petEffect()
--    local Timer = require("framework/client/api/Timer")
--    local appTimer = Timer.new()
--    -- 响应 CITYHALL_UPGRADE_TIMER 事件
--    local function onCityHallUpgradeTimer(event)
--        if event.countdown > 0 then
--			petEffect();
--        else
--        	appTimer:removeCountdown("pet_skill")
--        end
--    end
--	appTimer:addCountdown("pet_skill", 9999, 2)
--    appTimer:addEventListener("pet_skill", onCityHallUpgradeTimer)
--    appTimer:start()
	
	
	--边框
	local frame = display.newSprite( imagePath .. "petFrame.png")
	actionLayer:addChild( frame )
	
	
	--幻兽动画
	AnimatePacker:getInstance():loadAnimations(imagePath .. data.id .. "/effconfig.xml")
	local apsprite = CCSprite:create(imagePath .. data.id .."/eff.png")
	apsprite:runAction(CCRepeatForever:create(AnimatePacker:getInstance():getAnimate("action")))
	actionLayer:addChild(apsprite, 1)
	
	
	actionLayer:setVisible(false)
	content:addChild(actionLayer)
	
	
----------------------------------------------------------------------------------------------------------	
--	
--	静态画面相关
--	
	local staticLayer = display.newLayer()
	--背景
	local staticBg = display.newSprite(imagePath .. "static_bg.png")
	staticLayer:addChild(staticBg)
	--静止画面CD时间效果
	local staticEff = display.newSprite(imagePath .. "action_image.png")
	
	
	local function staticOverFun()
		staticLayer:setVisible(false)	--隐藏当前静止画面
		actionLayer:setVisible(true)--开始展示  CD激活动画
	end
	
	local to1 = CCProgressTo:create(data.cd, 100)
	
    local left = CCProgressTimer:create(staticEff)
    left:setType(kCCProgressTimerTypeRadial)
	staticLayer:addChild(left)
	
	left:runAction(transition.sequence({to1 , CCCallFunc:create(staticOverFun)}))  
	
	content:addChild(staticLayer)

----------------------------------------------------------------------------------------------------------	
--	
--	刷新界面数据
--		
	local function refreshData()
		local data = DATA_Battle:get( )["report"]["prepare"]["p1_pet"][1]
		
		dump( data )
		
		staticLayer:setVisible( true )--开始展示当前静止画面
		actionLayer:setVisible( false )--隐藏  CD激活动画
		
		to1 = CCProgressTo:create(data.cd, 100)
		
		left:runAction(transition.sequence({to1 , CCCallFunc:create(staticOverFun)}))  
	end	
----------------------------------------------------------------------------------------------------------	
--	
--	点击相关	动画效果展现的时候就可以操作，否则CD时间未到
--	
	local contentSize = frame:getContentSize()
	-- 点击区域记录
	local rect = CCRectMake(14 , 39 , contentSize.width , contentSize.height)
	
	local old_setPosition = content.setPosition
	function content:setPosition(x , y)
		rect = CCRectMake(x - contentSize.width / 2 , y - contentSize.height / 2 , contentSize.width , contentSize.height)
		old_setPosition(content , x , y)
	end
	-- 点击事件
	local function onTouch(eventType , x , y)
		
		if  isDisabled then
			return false
		end
		
	    if eventType == CCTOUCHBEGAN then 
	    	if not actionLayer:isVisible() then
	    		return false 
	    	end
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
				logic:pause("socket")
				local battle_call_data = {
					report_id = DATA_Battle:get("report_id"),
					turn = logic:getActionTurn(),
					step = logic:getActionStep() - 1,		-- 因为lua里，step是从1开始的，后台step是从0开始的，所以要-1
					pet_id = data.id,
				}
				
				SOCKET:getInstance("battle"):call("mission" , "execute_process" , "process" , battle_call_data , {
					error_callback = function(err)
						KNMsg.getInstance():flashShow("[" .. err.code .. "]" .. err.msg)	-- 弹出错误文字提示
						logic:resume("socket")
					end,
					success_callback = refreshData
				})
	        return true
	    end
	    return false
	end
	
	actionLayer:setTouchEnabled( true )
	actionLayer:registerScriptTouchHandler(onTouch)
	
		--禁用幻兽操作
	function content:setDisabled()
		isDisabled = true
	end
	
	return content
end

return M