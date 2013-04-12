local KNRadioGroup = {
	curBtn,   --记录选中的按钮
	items,
	cursor,    --当前选中的游标
	offset   --游标偏移
}
	
function KNRadioGroup:new(layer,cursor,offset)
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

function KNRadioGroup:chooseBtn(btn,noani)
	if self.curBtn then
		self.curBtn:select(false)
	end
	self.curBtn = btn
	btn:select(true)
	print(self.cursor)
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

function KNRadioGroup:cancelChoose()
	if self.curBtn then
		self.curBtn:select(false)
		self.curBtn = nil
	end
end

function KNRadioGroup:getChooseBtn()
	return self.curBtn
end

function KNRadioGroup:getId()
	return self.curBtn:getId()
end

function KNRadioGroup:addItem(btn)
	table.insert(self.items,btn)
end

function KNRadioGroup:chooseByIndex(index)
	self:chooseBtn(self.items[index])
end
return KNRadioGroup