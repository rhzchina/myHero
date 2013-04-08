
require "GameLuaScript/Common/KNButton"
--require "GameLuaScript/Common/KNBar"
require "GameLuaScript/Common/KNSlider"
require "GameLuaScript/UI/DialogLua"


local KNScrollViewX = require "GameLuaScript/Common/KNScrollViewX"
local KNScrollViewY = require "GameLuaScript/Common/KNScrollViewY"
require "GameLuaScript/Common/KNMsg"
nameAry={"packsack","friend","influence","card"}
--创建l底部的按钮layer
function BTLuaLayer()
  local BTLayer = CCLayer:create()
  local winSize = CCDirector:sharedDirector():getWinSize()
  
   local function ClickFun(type,params)
  --切换场景
   end
	--[[--组件进度条1
   local testStartBar = KNBar:new("perfection",20,50) 
   testStartBar:setActionPercent(100)
   print(testStartBar:getPercent())
   BTLayer:addChild(testStartBar)
   --组件进度条2
  local testStartBar2 = KNBar:new("perfection",20,100,{maxValue=80,icon = {x = 100,y = 100 }} ) 
   testStartBar2:setPercent(10)
   print(testStartBar2:getPercent())  
   BTLayer:addChild(testStartBar2)
   ]]--
 	--滑动控件1
    local m_pSliderCtl = KNSlider:new("slider_test",20,150,0, 100, 50, function(_mun) print(_mun.value)   end)
--    local m_pSliderCtl = KNSlider:new("slider_test",20,150,0, 100, 50, function(_mun) CCDirector:sharedDirector():getScheduler():setTimeScale(_mun.value)--设置速度   end)
    BTLayer:addChild(m_pSliderCtl)
  	--滑动控件2
    m_pSliderCtl2 = KNSlider:new("slider_test",20,200,-3, 3, 0, function(_mun) print(_mun.value)   end)
    BTLayer:addChild(m_pSliderCtl2)

   
	--文本设置2
    local textLabel = CCLabelTTF:create("Welcome " .. DATA_User:get("name") , "Thonburi", 20)
    display.align(textLabel , display.CENTER , display.cx , display.cy)
    -- textLabel:setPosition(180 , 180)
    textLabel:setColor( ccc3(255 , 0 , 0) )
    BTLayer:addChild(textLabel)

--   --搜索控件
--   local  search= KNcreateSearch(nameAry[1],100,300,ClickFun)
--   BTLayer:addChild(search)
	--底部按钮组
	local function createScroll()
		local scroll = KNScrollView:new(0,0,480,200,true)
		return scroll
	end
    local s = createScroll()
    local btnObj 
	nameAry = {"packsack" , "friend" , "influence" , "card" , "commonality"}
	for i = 1 , table.getn(nameAry) do
			local tempBtn=nil

			if(nameAry[i] == "commonality") then
				tempBtn = KNButton:new(nameAry[i],"公用按钮",20+(i-1)*90,778,ClickFun,5,1)--图文按钮
			else

            --图片按钮
			tempBtn,_,btnObj = KNButton:new(nameAry[i],0,20+(i-1)*90,778, function()

				-- 战斗
				local battle_call_data = {
					barrier_id = 1,
					map_id = 1,
					mission_id = 1,
				}
				SOCKET:getInstance("battle"):call("mission" , "execute" , "execute" , battle_call_data)

			end,2,1)
    	end
		s:addChild(tempBtn,btnObj:getItem())        
--		BTLayer:addChild(tempBtn)
	end
		s:alignCenter()
		BTLayer:addChild(s:getMainView())

	

    -- 拖动组件
    local temp_scroll_view = KNScrollViewX.new({
--      validTouchLeft = 300 , 
--      validTouchRight = 450 , 
      validTouchHeight = 10 , 
      validTouchTop = 450 , 
      validTouchBottom = 370 ,
    })

    for i = 1 , table.getn(nameAry) do
        local item = temp_scroll_view:newItem( {height = 80 } )
        -- item:addChild( display.newSprite("image/home_page/" .. i .. ".png") )
        local tempBtn = KNButton:new(nameAry[i] , 0 , 100 , 900 , function(type , param) 
            echoInfo("Click Button:  " .. type)
            -- 震动
            transition.shake(CCDirector:sharedDirector():getRunningScene() , {
              onComplete = function() print("shake onComplete") end
            })

            -- 隐藏文字
            textLabel:setVisible(false)
        end , nameAry[i] , i)
        
        item:addChild( tempBtn )
        temp_scroll_view:addItem( item )
    end
    
    temp_scroll_view:setPosition(200 , 200)
    temp_scroll_view:prepare()
    temp_scroll_view:enable()
   
    -- local temp_sprite = display.newSprite("image/home_page/Icon.png" , 100 , 100)
    BTLayer:addChild(temp_scroll_view)


	local card = display.newSprite("image/home_page/1002.png" , 240 , 500)
	card:getTexture():setAliasTexParameters()
	card:setAnchorPoint( ccp(0 , 0) )
	-- card:setSkewX(10)
	
	BTLayer:addChild(card)

	tempBtn = KNButton:new("friend" , 0 , 100 , 400 , function()
		--对话框的用法样例
		KNMsg.getInstance():flashShow("你犯错了，请改正!")
		KNMsg.getInstance():textShow("你犯错了，请改正!")
		KNMsg.getInstance():boxShow("你犯错了，请改正!",{confirmFun = function()print("确定执行成功！")end})
		KNMsg.getInstance():boxShow("你犯错了，请改正!",{cancelFun=function()print("取消执行成功")end})
		KNMsg.getInstance():boxShow("你犯错了，请改正!",{confirmFun = function()print("确定执行成功！")end,cancelFun=function()print("取消执行成功")end})
	   
	    transition.rotateTo( card , {time = 0.06 , angle = -40} )
	    transition.rotateTo( card , {delay = 0.08 , time = 0.08 , angle = 0 , easing = "BACKOUT"} )

	    transition.moveBy( card , {time = 0.08 , y = 10  } )
	    transition.moveBy( card , {delay = 0.08 , time = 0.06 , y = -10 } )
	    --[[
			transition.rotateTo( card , {time = 0.06 , angle = 8} )
			-- transition.rotateTo( card , {delay = 0.1 , time = 0.5 , angle = 0 , easing = "ELASTICOUT"} )
			transition.rotateTo( card , {delay = 0.06 , time = 0.1 , angle = -25} )
			transition.rotateTo( card , {delay = 0.16 , time = 0.06 , angle = 0} )

			transition.moveBy( card , {time = 0.08 , x = 5 , y = 8  } )

	    transition.moveBy( card , {delay = 0.08 , time = 0.06 , x = -5 , y = -8} )

	    ]]--

      -- HTTP:call("login" , "develop" , {open_id = "willzhou"})      -- 登录
		
	end,2,1)
	BTLayer:addChild(tempBtn)
	local function tempBattleFun()				-- 战斗
		local battle_call_data = {
			barrier_id = 1,
			map_id = 1,
			mission_id = 1,
		}
		SOCKET:getInstance("battle"):call("mission" , "execute" , "execute" , battle_call_data)
	end
	local battBtn=KNButton:new("red","战斗测试",300,600,tempBattleFun,5,1)
	BTLayer:addChild(battBtn)
	
	--类似Viewpager的示例
	local view = KNScrollView:new(100,300,75,101,true,1)
	local page = CCSprite:create("image/home_page/1002.png")
	local page1 = CCSprite:create("image/home_page/4001.png")
	local page2 = CCSprite:create("image/home_page/4004.png")
	local page3 = CCSprite:create("image/home_page/4005.png")
	local page4 = CCSprite:create("image/home_page/4006.png")
	local page5 = CCSprite:create("image/home_page/4008.png")
	local page6 = CCSprite:create("image/home_page/4009.png")
	local page7 = CCSprite:create("image/home_page/4012.png")
	view:addChild(page)
	view:addChild(page1)
	view:addChild(page2)
	view:addChild(page3)
	view:addChild(page4)
	view:addChild(page5)
	view:addChild(page6)
	view:addChild(page7)
	BTLayer:addChild(view:getMainView())
--
--	AnimatePacker:getInstance():loadAnimations("image/effect_test/skill.xml")
--	local apsprite = CCSprite:create("image/effect_test/sssss.png")
--	apsprite:setPosition(ccp(100, 100))
--	apsprite:runAction(CCRepeatForever:create(AnimatePacker:getInstance():getAnimate("skill")))
--	BTLayer:addChild(apsprite, 1)
	
	
	AnimatePacker:getInstance():loadAnimations("image/pet/250/effconfig.xml")
	local apsprite = CCSprite:create("image/pet/250/eff.png")
	apsprite:runAction(CCRepeatForever:create(AnimatePacker:getInstance():getAnimate("action")))
	BTLayer:addChild(apsprite, 1)

--[[
  local frames = display.newFrames("image/fight/pet/250/%d.png" , 1 , 36 , false , true)
  local sprite
  sprite = display.playFrames(
    300 ,
    300,
    frames,
    0.05,
    {
      onComplete = function()
        sprite:removeFromParentAndCleanup(true)  -- 清除自己
      end
    }
  )
  BTLayer:addChild(sprite)
]]--

--[[
  local KNLoading = require("GameLuaScript/Common/KNLoading")
  local loading = KNLoading.new()
  loading:click(function() loading:remove() end)
  BTLayer:addChild( loading )
]]

--[[
  	local function getAllSprites( root )
		local sprites = {}

		local function _getAllSprites( _root )
			local childs_num = _root:getChildrenCount()
			if childs_num == 0 then return end

			local childs = _root:getChildren()
			for i = 0 , childs_num - 1 do
				local child = tolua.cast( childs:objectAtIndex(i) , "CCNode")

				if child:getTag() == 102 then
					sprites[#sprites + 1] = child
				end

				getAllSprites(child)
			end
		end

		_getAllSprites( root )

		return sprites
  	end
  	

	dump( getAllSprites(BTLayer) )
]]




   
--  BTLayer:addChild(creatDialog("box.jpg",100,100))
--  BTLayer:addChild(creatlabe("asdasd",100,100,20,0,0,0))
--  BTLayer:addChild(creatlabe("222222222",100,150,30,0,0,0))
  return BTLayer
end
