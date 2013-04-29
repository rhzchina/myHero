local LuaRadioGroup = {
	curBtn,   --记录选中的按钮
	items,
	cursor,    --当前选中的游标
	offset   --游标偏移
}
	
function LuaRadioGroup:new(layer,cursor,offset)
	local this = {}
	setmetatable(this,self)
	self.__index = self
	this.items = {}
	
	if layer and cursor then
		this.cursor = display.newSprite(cursor)
		setAnchPos(this.cursor)
		this.cursor:setVisible(false)
		layer:addChild(this.cursor,-1)
			this.offset = offset or 0
	end
	
	return this	
end

function LuaRadioGroup:chooseBtn(btn,noani,callback)
	if self.curBtn then
		self.curBtn:select(false)
	end
	self.curBtn = btn
	btn:select(true,callback)
	if self.cursor then
		self.cursor:setVisible(true)
		local x = btn:getX() - (self.cursor:getContentSize().width - btn:getWidth()) / 2 + self.offset
		local y = btn:getY() - (self.cursor:getContentSize().height - btn:getHeight()) / 2
		if noani then
			setAnchPos(self.cursor,x,y)
		else
			self.cursor:runAction(CCMoveTo:create(0.2,ccp(x,y)))		
		end
	end
end

function LuaRadioGroup:cancelChoose()
	if self.curBtn then
		self.curBtn:select(false)
		self.curBtn = nil
	end
end

function LuaRadioGroup:getChooseBtn()
	return self.curBtn
end

function LuaRadioGroup:getId()
	return self.curBtn:getId()
end

function LuaRadioGroup:addItem(btn)
	table.insert(self.items,btn)
end


function LuaRadioGroup:chooseByIndex(index,callback)
	self:chooseBtn(self.items[index],nil,callback)
end

function LuaRadioGroup:chooseById(id)
	for k,v in pairs(self.items) do
		if v:getId() == id then
			self:chooseBtn(v,nil,true)
			break
		end
	end
end
return LuaRadioGroup