local KNRadioGroup = {
	curBtn,   --记录选中的按钮
	items,
}
	
function KNRadioGroup:new()
	local this = {}
	setmetatable(this,self)
	self.__index = self
	this.items = {}
	
	return this	
end

function KNRadioGroup:chooseBtn(btn)
	if self.curBtn then
		self.curBtn:select(false)
	end
	self.curBtn = btn
	btn:select(true)
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