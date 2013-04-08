local NORMAL, SELECTED, DISABLE  = 1, 2, 3
local scale = 1.2
local highLight = {time = 0,r = 0,g = 200,b = 100}
local KNBtn = {
	layer,
	item ,
	params,  
	programChange,  --是否是程序改变的改果
	chosen,           -- 按钮允许选中时此变量表示已选择状态
	group,          --按钮所在的按钮组
	state,         --按钮当前状态
}


--[[
	参数file必须是一个table存放按钮的效果图片名称                                              ( {"普通","选中","禁用"})   普通图片必须存在，其余任选
	
	额外的参数， params = {}
	callback:     单击回调函数，                                                                            (function)
	selectable:   单击后处于选中,默认false,                     (true,false)
	scale：                  若无图片，则程序默认放大效果，                                               (true,false)
	hightLight:   若无图片，则程序默认高亮效果，默认效果可以同时叠加使用 (true,false)
	front,        当有通用背景时，此参数可做按钮文字                                       (string)
	group:        是否在单选按钮组                                                                         (KNRadioGroup)
	upSelect      弹起时选中 ，只在弹起时触发选中状态                                       (true,false)
	noHide        在选中状态时，是否隐藏普通状态图 片，用于选中状态是加边框的效果
	text          程序绘制文字时添加此参数   ("string")
	disableWhenChoose,        当按钮被选中时，再次点击是否触发callback,为true时不再触发
]]
function KNBtn:new(path, file, x, y, params, group)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.params = params or {}
	this.item = {}
	this.group = group
	this.layer = display.newLayer()
	setAnchPos(this.layer, x, y)
	
	if string.sub(path,string.len(path)) == "/" then  --去掉末尾的分隔符
		path = string.sub(path,0,string.len(path) - 1)
	end
	--跟据参数初始化按钮状态图片
	for i = 1, table.getn(file)	do
		if file[i] then
			this.item[i] = display.newSprite(path.."/"..file[i])
			if i == SELECTED then  --默认1，普通，2：选中，3：禁用
				local cur = this.item[i]
				setAnchPos(cur,-(cur:getContentSize().width - this.item[1]:getContentSize().width ) / 2,
					 -(cur:getContentSize().height - this.item[1]:getContentSize().height ) / 2)
			else
				setAnchPos(this.item[i])
			end
			this.item[i]:setVisible(false)		
			this.layer:addChild(this.item[i])
		else
			this.item[i] = "nil"
		end
	end
	this.layer:setContentSize(CCSize:new(this.item[1]:getContentSize().width,this.item[1]:getContentSize().height))
	
	if this.params["front"] then
		local front = display.newSprite(this.params["front"])
		setAnchPos(front,(this.layer:getContentSize().width - front:getContentSize().width) / 2, 
				(this.layer:getContentSize().height - front:getContentSize().height) / 2)
		this.layer:addChild(front)
	end
	
	if this.params["text"] then
		local text = CCLabelTTF:create(this.params["text"][1],"font.ttf",this.params["text"][2])
		setAnchPos(text,(this.layer:getContentSize().width - text:getContentSize().width) / 2, 
				(this.layer:getContentSize().height - text:getContentSize().height) / 2)
		if this.params["text"][3] then --是否有颜色
			text:setColor(this.params["text"][3])
		end
		this.layer:addChild(text)
	end
	
	
	local press , moveOn   --press为是否按下，moveOn 为按钮按下后是否有移动 j
	local lastX = 0  -- lastX 最后点击的坐标
	
	if not this.params["disable"] then
		this.layer:setTouchEnabled(true)
	end
	function this.layer:onTouch(type, x, y) 
		if this.state == DISABLE then  --禁 用状态直接返回
			return false
		end
		if this.params["parent"] and not CCRectMake(this.params["parent"]:getX(),    --若有父组件时，点击到组件外部时不响应
			this.params["parent"]:getY(), this.params["parent"]:getWidth(),
				params["parent"]:getHeight()):containsPoint(ccp(x,y)) then
				press = false
				moveOn = false
				lastX = 0
				if group and group:getChooseBtn()  ~= this then
					this:select(false)
				end
				return false
		else
			if type == CCTOUCHBEGAN then
				if this:getRange():containsPoint(ccp(x,y)) then
					press = true
					moveOn = true
					lastX = x
				
					if not this.params["upSelect"] then  --抬起选中效果时不触发选中状态
						this:setState(SELECTED)	
					end
				else
					return false
				end
			elseif type == CCTOUCHMOVED then
				if this.params["upSelect"] then
					if math.abs(x - lastX) > 25 or not this:getRange():containsPoint(ccp(x,y)) then
						press = false
						moveOn = false
						return false
					end
				else
					if this:getRange():containsPoint(ccp(x,y)) then
						if press then
							moveOn = true
							this:setState(SELECTED)
						end
					else
						if press then 
							moveOn = false
							if group or params["selectable"] then  --若按钮有选中状态
								if group then     --在单选按钮组中时优先设置
									if group:getChooseBtn()	~= this then
										this:setState(NORMAL)
									end						
								else	
									if not this.chosen then
										this:setState(NORMAL)
									end
								end
							else                                  --普通按钮
								this:setState(NORMAL)
							end
						end
					end
				end
			elseif type == CCTOUCHENDED then
				if this:getRange():containsPoint(ccp(x,y)) then
					if press and moveOn then
						--放开后执行回调 
						if this.params["callback"] then
							if not this.params["disableWhenChoose"] then
								this.params["callback"]()
							else
								if not this.chosen then
									this.params["callback"]()
								end
							end						
						end
					
						--设置是否选中
						if not this.params["selectable"]	then
							this:setState(NORMAL)
						else
							this.chosen = true   
						end					
					
						if group then
							group:chooseBtn(this)
						end
					end
				else
				end
				press = false
				moveOn = false
				lastX = 0
			end
		end
		return true
	end
	this.layer:registerScriptTouchHandler(function(type,x,y) return this.layer:onTouch(type,x,y) end,false,-128,false)
	this:setState(NORMAL)
	if group then
		group:addItem(this)	
		if not group:getChooseBtn() then
			group:chooseBtn(this)
		end
	end
	return this		
end

function KNBtn:getLayer()
	return self.layer
end

function KNBtn:setState(state)
	self.state = state
	local done = false
	for i = 1, table.getn(self.item) do
		if self.item[i] ~= "nil" then
			if i == state then
				done = true
				self.item[i]:setVisible(true)
			
				if i == NORMAL and self.programChange then --当设置回普通状态时,若是程序改变的效果则回复原状态
					if self.params["scale"] then
						self.item[1]:setScale(1)
						setAnchPos(self.item[1])
					end
					if self.params["highLight"] then
						transition.tintTo(self.item[1])
					end
				end
			else	
				self.item[i]:setVisible(false)
			
				if state == SELECTED and self.params["noHide"] then 
					self.item[i]:setVisible(true)
				end
			end
		end
	end
	
	--若设置失败，说明图片不存在则使用程序的方式进行改变
	if not done then
		if state == SELECTED then
			if self.params["scale"] then
				local cur = self.item[1]
				cur:setVisible(true)
				cur:setScale(scale)
				setAnchPos(cur,-(cur:getContentSize().width * scale - cur:getContentSize().width ) / 2,
				 -(cur:getContentSize().height * scale - cur:getContentSize().height ) / 2)
			end
			if self.params["highLight"] then
				self.item[1]:setVisible(true)
				transition.tintTo(self.item[1],highLight)
			end 
			self.programChange = true
		else
		end
	end
end

function KNBtn:select(selecte)
	if self.group or self.params["selectable"] then
		if selecte then 
			self:setState(SELECTED)
		else
			self:setState(NORMAL)
		end
		self.chosen = selecte
	end
end

--获取所有父组件，取得按钮的绝对位置
function KNBtn:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	x = x + parent:getPositionX()
	y = y + parent:getPositionY()
	while parent:getParent() do
		parent = parent:getParent()
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()		
	end
	return CCRectMake(x,y,self.layer:getContentSize().width,self.layer:getContentSize().height)
end

function KNBtn:showBtn(bool)
	self.layer:setVisible(bool)	
end
--当前显示状态
function KNBtn:getShow()
	self.layer:isVisible()	
end

function KNBtn:setEnable(bool)
	self.layer:setTouchEnabled(bool)
end

function KNBtn:getWidth()
	return self.layer:getContentSize().width
end

function KNBtn:getHeight()
	return self.layer:getContentSize().height
end

function KNBtn:setPosition(x,y)
	self.layer:setPosition(ccp(x,y))
end

function KNBtn:setFlip(horizontal)
	if horizontal then
		for i = 1, #self.item do
			self.item[i]:setFlipX(true)
		end
	else
		for i = 1, #self.item do
			self.item[i]:setFlipY(true)
		end
	end
end

function KNBtn:getId()
	return self.params["id"]
end
--function KNBtn:setPosition(x,y)
--	local tx, ty = x, y
--	if self.params["parent"] then
--		tx = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		ty = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
--	self.touchRange = CCRectMake(tx,ty,self.layer:getContentSize().width,self.layer:getContentSize().height)
--end


return KNBtn