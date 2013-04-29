local NORMAL, CHOOSE, LOCK = 1, 2, 3

local LuaCheckBox = {
	layer,
	choose,
	lock,
	params,
	state,  --复选框状态
}
	
--[[
	params参数说明：
	path: 目录
	file={"背景","选中","锁定"}
	state:初始化时的状态，默认为普通
	checkBoxOpt:  选择复选框时的操作 
	]]
function LuaCheckBox:new(x,y,params)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.layer = CCLayer:create()
	this.params = params or {}
	this.state = params["state"] or NORMAL
	
	if string.sub(params["path"],string.len(params["path"])) == "/" then  --去掉末尾的分隔符
		params["path"] = string.sub(params["path"],0,string.len(params["path"]) - 1)
	end
	
	--复选框背景，必需
	local bg = display.newSprite(params["path"].."/"..params["file"][1])
	setAnchPos(bg)
	this.layer:addChild(bg)
	
	--复选框选中状态，必须
	this.choose = display.newSprite(params["path"].."/"..params["file"][2])
	setAnchPos(this.choose)
	this.layer:addChild(this.choose)
	
	--复选框锁定，可选
	if params["file"][3] then
		this.lock  = display.newSprite(params["path"].."/"..params["file"][3])
		setAnchPos(this.lock)
		this.layer:addChild(this.lock)
	end
	
	this:setState(this.state)	
	this.layer:setContentSize(bg:getContentSize())
	setAnchPos(this.layer,x,y)
	
	this.layer:setTouchEnabled(true)
	this.layer:registerScriptTouchHandler(
	function(type,x,y)
		if type == CCTOUCHBEGAN then
			if this:getRange():containsPoint(ccp(x,y)) then
				if this.state ~= LOCK then
					if this.state == NORMAL then
						this:setState(CHOOSE)
					elseif this.state == CHOOSE then
						this:setState(NORMAL)
					end
					if this.params["checkBoxOpt"] then
						this.params["checkBoxOpt"]()
					end
				end
			end
		end
		return false
	end,false,-150,false)
	return this
end

function LuaCheckBox:getLayer()
	return self.layer
end

function LuaCheckBox:setState(state)
	if state == NORMAL then
		self.choose:setVisible(false)
		if self.lock then
			self.lock:setVisible(false)
		end
	elseif state == CHOOSE then
		self.choose:setVisible(true)	
		if self.lock then
			self.lock:setVisible(false)
		end
	else
		self.choose:setVisible(false)
		if self.lock then
			self.lock:setVisible(true)
		end
	end
	self.state = state
end

function LuaCheckBox:check(bool)
	if bool then
		self:setState(CHOOSE)
	else
		self:setState(NORMAL)
	end
end

function LuaCheckBox:show(bool)
	self.layer:setVisible(bool)
end

function LuaCheckBox:isSelect()
	return self.state == CHOOSE
end

function LuaCheckBox:getRange()
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
return LuaCheckBox
