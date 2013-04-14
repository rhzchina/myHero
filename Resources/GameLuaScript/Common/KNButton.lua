KNButton={}
KNButton.__index=KNButton
function KNButton:new(pathStr,t,x,y,backFun,id,params)
	local this={}
	setmetatable(this,KNButton)
	this.pathStr=pathStr or ""
	this.type=t or "0"
	this.x=x or 0
	this.y=y or 0
	this.backFun=backFun or function()end
	this.id=id or 0
	this.params=params or {}
	this.tempItem=nil --临时菜单项
	this.setEnabledLua=function()end
	
	local btn=CCMenu:create()
	btn.type=this.id
	btn.params=this.params;
	
	--生成MenuItem
	function createItem(pathStr,t,x,y,id)
	   	local menuItem= CCMenuItemImage:create()
	    --按钮单击回调函数
		if t==IMAGEBUTTON then--图片按钮
			local buttonPath =  IMAGEPATH.."/buttonUI/"..pathStr.."/"
			
			--判断按钮的禁用图片是否存在
			if type(this.params) == "table" and this.params["noDisable"] then
				menuItem = CCMenuItemImage:create(buttonPath.."def.png",buttonPath.."pre.png")
			else
				menuItem = CCMenuItemImage:create(buttonPath.."def.png",buttonPath.."pre.png",buttonPath.."dis.png")
			end
			
			menuItem:setAnchorPoint(ccp(0,0))
			btn:setPosition(ccp(display.width-(display.width-x),display.height-y))
		elseif type==TEXTBUTTON then--文本按钮
			local testLabel = CCLabelTTF:create(pathStr,"Arial",24)
--			createStroke(testLabel,10,ccc3(0,0,255))
       		menuItem = CCMenuItemLabel:create(testLabel)
       		--set font color
       		menuItem:setColor(ccc3(255,0,0))
       		--center
       		menuItem:setAnchorPoint(ccp(0.5,0.5))
       		btn:setPosition(ccp(display.width-(display.width-x)+testLabel:getTextureRect().size.width/2,display.height-y+testLabel:getTextureRect().size.height/2))
   		else--图文按钮
   			menuItem=createItem(pathStr,0,x,y,id)--生成底图
		end
		return menuItem
	end

	

   	
   	this.tempItem=createItem(pathStr,type,x,y,id)
   	
    if(this.backFun) then
		this.tempItem:registerScriptTapHandler(function() backFun(btn.type,btn.params) return true end)
	end
	btn:addChild(this.tempItem)

	local itemSize = this.tempItem:getContentSize()
	if(this.type~=IMAGEBUTTON and this.type~=TEXTBUTTON) then
		this.text=CCLabelTTF:create(this.type, "Thonburi", 16)
		this.textMenuItem = CCMenuItemLabel:create(this.text)
		local textSize = this.text:getContentSize()
		this.textMenuItem:setAnchorPoint(ccp(0,0))
		this.textMenuItem:setPosition(ccp((itemSize.width-textSize.width)/2,textSize.height/2))
		btn:addChild(this.textMenuItem)
	end
	btn:setContentSize(itemSize)
	
	
	--按钮(禁用/激活)
	function btn:setEnabledLua(flag)
		btn:setEnabled(flag)
		if(this.type~=TextButton) then
			--图片按钮
			if(flag) then
				this.tempItem:setEnabled(flag)
			else
				this.tempItem:setEnabled(flag)
			end
		else
			--文字按钮
			if(flag) then
	
			else
			
			end
		end

	end
	--按钮是否隐藏
	function btn:setVisibleLua(flag)
		btn:setVisible(flag)
	end


	-- 设置点击事件优先级
	function btn:setHandlerPriorityLua(newPriority)
		local handle
		local function temp_func()
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
			btn:setHandlerPriority(newPriority)
		end

		handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(temp_func , 0.01 , false)
	end

    return btn , itemSize,this
end

function KNButton:getItem()
	return self.tempItem
end

function KNButton:getId()
	return self.id
end
--处理点击以后按钮是否处于选中状态
function KNButton:setSelected(select)
	if select then
		self.tempItem:selected()
	else
		self.tempItem:unselected()
	end
end


return KNButton
--label 描边 
--function createStroke(label,size,color)
--
--	local x=label:getTexture():getContentSize().width+size*2
--	local y=label:getTexture():getContentSize().height+size*2
--	
--	
--	local originalPos=label:getPosition()
--	
--	local originalColor=label:getColor()
--	
--	local rt=CCRenderTexture:create(x, y)
--	label:setColor(color)--ccc3数据
--	
--	local originalBlend=label:getBlendFunc()
--	local bf1 = ccBlendFunc:new()
--	bf1.src = 1     -- GL_ONE
--	bf1.dst = 0     -- GL_ZERO
--	label:setBlendFunc(bf1)
--	local center=ccp(x/2+size, y/2+size)
--	
--	rt:begin()
--	for i=0,360,15 do
--		_x=center.x+math.sin(math.rad(i))*size
--		_y=center.y+math.cos(math.rad(i))*size
--		label:setPosition(ccp(_x, _y))
--		label:visit()
--	end
--	rt:endToLua()
--	
--	label:setPosition(originalPos)
--	label:setColor(originalColor)
--	label:setBlendFunc(originalBlend)
--	
--	rtX=originalPos.x-size
--	rtY=originalPos.y-size
--	
--	rt:setPosition(ccp(rtX, rtY))
--end

--CCRenderTexture* playScene::createStroke(cocos2d::CCLabelTTF *label,floatsize, cocos2d::ccColor3B color)
--{
--	floatx=label->getTexture()->getContentSize().width+size*2;
--	floaty=label->getTexture()->getContentSize().height+size*2;
--	CCRenderTexture *rt=CCRenderTexture::create(x, y);
--	CCPoint originalPos=label->getPosition();
--	ccColor3B originalColor=label->getColor();
--	label->setColor(color);
--	ccBlendFunc originalBlend=label->getBlendFunc();
--	label->setBlendFunc((ccBlendFunc){GL_SRC_ALPHA,GL_ONE});
--	CCPoint center=ccp(x/2+size, y/2+size);
--	rt->begin();
--	for(inti=0; i<360; i+=15)
--	 {
--		float_x=center.x+sin(CC_DEGREES_TO_RADIANS(i))*size;
--		float_y=center.y+cos(CC_DEGREES_TO_RADIANS(i))*size;
--		
--		label->setPosition(ccp(_x, _y));
--		label->visit();
--	
--	}
--	rt->end();
--	label->setPosition(originalPos);
--	label->setColor(originalColor);
--	label->setBlendFunc(originalBlend);
--	floatrtX=originalPos.x-size;
--	floatrtY=originalPos.y-size;
--	
--	rt->setPosition(ccp(rtX, rtY));
--	
--	returnrt;
--}