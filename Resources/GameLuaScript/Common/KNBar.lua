--[[
	进度条
]]--
local M = {}
--KNBar = {path="",x=0,y=0,percent = 0,container = nil,param={}}
--这句是重定义元表的索引，就是说有了这句，这个才是一个类。具体的解释，请百度。
--KNBar.__index = KNBar
--构造体，构造体的名字是随便起的，习惯性改为new()
--function KNBar:new(pathStr,x,y, param)
function M:new(pathStr,x,y, param)
		--[[{
			"icon" : {"icon_x" : 100,"icon_y" : 188}
			"text" : {}
		}]]--

--        local this = {}  --初始化this，如果没有这句，那么类所建立的对象改变，其他对象都会改变
--        setmetatable(this, KNBar)  --将this的元表设定为Class
        local this = {}
        this.path = path   --属性值初始化
        this.x = x
        this.y = y
        this.actionOne = true	--是否是第一次执行动画效果
        --设置默认值
        if param == nil or type( param ) ~= "table"  then param = { maxValue = 100 , curValue = 0 } end


        if(isset(param , "maxValue")) then
       	 	this.maxValue = param.maxValue	--最大值
        else
       		 this.maxValue =100	--最大值
        end

        if(isset(param , "curValue")) then
       	 	this.curValue = param.curValue	--当前值
        else
       		 this.curValue =0	--当前值
        end

        this.textSize = param.textSize or 18



        local container = CCNode:create()--创建对像容器
        local KNBarPath ="image/start_bar/" .. pathStr .. "/"


       	-- 进度条背景
        this.bg = display.newSprite(KNBarPath .. "bg.png")  -- 创建背景
        this.bg:setAnchorPoint(ccp(0 , 0.5))	-- 设置锚点
        container:addChild(this.bg)

        -- 进度条前景
        local front = display.newSprite(KNBarPath .. "fore.png")
       	this.KNBar = CCProgressTimer:create(front)
	    this.KNBar:setType(kCCProgressTimerTypeBar)
	    -- Setup for a KNBar starting from the left since the midpoint is 0 for the x
	    this.KNBar:setMidpoint(CCPointMake(0 , 0))--设置进度方向 (0-100)
	    -- Setup for a horizontal KNBar since the KNBar change rate is 0 for y meaning no vertical change
        this.KNBar:setAnchorPoint(ccp(0 , 0.5)) --设置锚点
	    this.KNBar:setBarChangeRate(CCPointMake(1, 0)) --动画效果值(0或1)
	    this.KNBar:setPosition(CCPointMake(0, 0))
     	this.KNBar:setPercentage(0)	--设置默认进度值

	   	--进度条文字
	   	this.text = CCLabelTTF:create("0/" .. this.maxValue , FONT , 15)
	   	this.text:setAnchorPoint( ccp(0.5 , 0.5) )
	   	local textSize = this.text:getContentSize()
	   	local bgSize = this.bg:getContentSize()
	   	this.text:setPosition( bgSize.width / 2 , 0 )
	   	container:addChild(this.text , 7)




	   	--进度条Icon
	   	if(isset(param , "icon")) then
		   	local icon = display.newSprite(KNBarPath .. "icon.png")
		   	local iconX = param.icon.x or 0
		   	local iconY = param.icon.y or 0
		   	local iconSize = icon:getContentSize()
		   	icon:setAnchorPoint(ccp(0 , 0.5))
		   	icon:setPosition(0,0)
		   	container:addChild( icon , 6)
		   	this.KNBar:setPosition(CCPointMake(iconSize.width/2 + 12, 0))
		   	this.bg:setPosition(ccp(iconSize.width/2 + 12 , 0))
	   		this.text:setPosition( bgSize.width / 2 + iconSize.width/2 + 17, 0 )

	   	end




		container:addChild(this.KNBar)
        container:setPosition(ccp(display.width-(display.width-this.x),display.height-this.y))--设置坐标




        --通过设置绝对值，修改界面。
        function container:setCurValue(_num , is_action)
            this.curValue = _num
            local percent = this.curValue / this.maxValue

            if is_action then
                container:setActionPercent(percent)
            else
                container:setPercent(percent)
            end
        end

        --通过设置百分比，修改界面。   无动画设置进度值
        function container:setPercent(_num)
        	--无动画
        	this.curValue = _num * this.maxValue
        	this.text:setString(this.curValue .. "/" .. this.maxValue)
        	this.KNBar:setPercentage(this.curValue / this.maxValue * 100)   --无动画效果
        end

        --通过设置百分比，修改界面。   有动画进度设置
        function container:setActionPercent(_num)
        	--无动画
        	this.curValue = _num * this.maxValue
        	this.text:setString(this.curValue .. "/" .. this.maxValue)
        	--有动画效果
    	 	local to1
        	if  this.actionOne  then
        		this.actionOne = false
    	 	    to1 = CCProgressTo:create(0,this.curValue/this.maxValue*100)
        		this.KNBar:runAction(to1)--执行一次
        	else
        		if this.curValue < this.maxValue then
	    	       	to1 = CCProgressTo:create(0.1,this.curValue/this.maxValue*100)
	        		this.KNBar:runAction(to1)--执行一次
	        	end
        	end

        end

        --返回进度值
        function container:getPercent()
        	return this.KNBar:getPercentage()
        end


        --返回当前值
        function container:getPercentValue()
        	return this.KNBar:getPercentage()/100*this.maxValue
        end




        --设置最大值
        function container:setMaxValue(_num)
        	this.maxValue=_num
        	container:setPercent(this.curValue/this.maxValue)
        end
        --返回最大值
        function container:getMaxValue()
        	return this.maxValue
        end


        --是否显示文字
        function container:setIsShowText( isShow )

        	this.text:setVisible( isShow )

        end

        container:setPercent(this.curValue/this.maxValue)
     	return container  --返回自身
end

--return KNBar
return M







