local taskinfo = requires(SRC.."Scene/roost/taskInfo")

local roostLayer = {
	layer,
	contentLayer
}
function roostLayer:new(x,y)
	local this = {}
	setmetatable(this,self)
	self.__index  = self

	this.layer = CCLayer:create()
	local bg = newSprite(IMG_COMMON.."common_bg1.png")
	setAnchPos(bg,0,85)
	this.layer:addChild(bg)

	local fontbg = newSprite(IMG_SCENE.."mission/level_name_bg.png")
	setAnchPos(fontbg,0,625)
	this.layer:addChild(fontbg)

	local line = newSprite(IMG_SCENE.."mission/line.png")
	setAnchPos(line,10,513)
	this.layer:addChild(line)

	local bsv 
	bsv = ScrollView:new(54,640,440,50,0,true,1, {
		page_callback = function()
				if DATA_Mission:get("sHurdle", bsv:getCurIndex()) then
						this:createMission(bsv:getCurIndex())
				else		
					HTTPS:send("Task", {a = "task", m = "task", task = "select_hurdle", bHurdle_id = DATA_Mission:get("bHurdle", bsv:getCurIndex(), "id")},{
						success_callback = function()	
							this:createMission(bsv:getCurIndex())
						end
					})	
				end
		end
	})
	for i = 1, #DATA_Mission:get("bHurdle")  do --DATA_MapNum:size()
		local nameLayer = newLayer()
		local name = newLabel(DATA_Mission:get("bHurdle",i,"name"), 30, {x = 100, y = -5})
		
		nameLayer:setContentSize(CCSizeMake(440,30))
		nameLayer:addChild(name)
		
		bsv:addChild(nameLayer)
	end

	this.layer:addChild(bsv:getLayer())


	local left_bt = Btn:new(IMG_BTN,{"left_normal.png","left_press.png"},5,625,
    		{
    			callback=
    				function()
    					if bsv:getCurIndex() > 1 then
    						bsv:setIndex(bsv:getCurIndex() - 1, true)
    					end
    				
    				 end
    		 })

	this.layer:addChild(left_bt:getLayer())


	local right_bt = Btn:new(IMG_BTN,{"right_normal.png","right_press.png"},430,625,
    		{
    			callback=
    				function()
    						if bsv:getCurIndex() < #DATA_Mission:get("bHurdle") then
								bsv:setIndex(bsv:getCurIndex() + 1, true) 
    					end
    				 end
    		 })

	this.layer:addChild(right_bt:getLayer())

	this:createMission(1)
return this
end

function roostLayer:createMission(level)
	if self.contentLayer then
		self.layer:removeChild(self.contentLayer, true)
	end
	self.contentLayer = newLayer()
	
	local des = Label:new(DATA_Mission:get("bHurdle",level, "exps"), 22, 420,18)
	setAnchPos(des, 18, 562)
	self.contentLayer:addChild(des)

	local task
	local task_x = 0
	local task_y = 100
	local ksv = ScrollView:new(0,90,480,420,10,false)
	for i = 1, #DATA_Mission:get("sHurdle", level)  do
			task = taskinfo:new(ksv,DATA_Mission:get("sHurdle",level, i),task_x,task_y)
			ksv:addChild(task:getLayer(),task)
			task_y = task_y -180
	end

	self.contentLayer:addChild(ksv:getLayer())
	
	self.layer:addChild(self.contentLayer)
end

function roostLayer:getLayer()
	return self.layer
end

return roostLayer
