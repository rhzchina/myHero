local roostLayer = {layer}
function roostLayer:new(x,y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self

	this.layer = CCLayer:create()
	local bg = newSprite(IMG_COMMON.."common_bg1.png")
	setAnchPos(bg,0,85)
	this.layer:addChild(bg)

	local fontbg = newSprite("image/scene/task/fontbg.png")
	setAnchPos(fontbg,0,625)
	this.layer:addChild(fontbg)

	local line = newSprite("image/scene/task/line.png")
	setAnchPos(line,10,513)
	this.layer:addChild(line)

	---- [[大关卡]]
	local bsv = ScrollView:new(54,640,440,50,0,true,1)
	for i = 1,1  do --DATA_MapNum:size()
			local text_font = newLabel("关卡名字", 25)
			--text_font:setContentSize(CCSize(100,100))
			bsv:addChild(text_font,text_font)
	end

	this.layer:addChild(bsv:getLayer())


	--左按钮
	local left_bt = Btn:new(IMG_BTN,{"left_normal.png","left_press.png"},5,625,
    		{
    			--front = v[1],
    			highLight = true,
    			scale = true,
				--selectable = true,
    			callback=
    				function()
    					--switchScene("battlere")
    				 end
    		 })

	this.layer:addChild(left_bt:getLayer())


	local right_bt = Btn:new(IMG_BTN,{"right_normal.png","right_press.png"},430,625,
    		{
    			--front = v[1],
    			highLight = true,
    			scale = true,
				--selectable = true,
    			callback=
    				function()
    					--switchScene("battlere")
    				 end
    		 })

	this.layer:addChild(right_bt:getLayer())

	local taskinfo = require"GameScript/Scene/roost/taskInfo"
	local task
	local task_x = 0
	local task_y = 100
	local ksv = ScrollView:new(0,90,480,420,10,false)
	for i = 1,DATA_MapSmall:size()  do
			task = taskinfo:new(ksv,DATA_MapSmall:get(i),task_x,task_y)
			ksv:addChild(task:getLayer(),task)
			task_y = task_y -180
	end

	this.layer:addChild(ksv:getLayer())

return this
end

function roostLayer:getLayer()
	return self.layer
end

return roostLayer
