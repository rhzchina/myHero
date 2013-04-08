MissionLayer = {}

function MissionLayer:create(x,y)
	local this={}
	setmetatable(this,self)
	self.__index = self

	local layer = display.newLayer()
	local bg = CCSprite:create("image/scene/home/mission_bg.jpg")
	bg:setAnchorPoint(ccp(0,0))
	bg:setPosition(ccp(x,y))
	layer:addChild(bg)

	--初始化大关卡信息
	local function initGrade()
		local gradeInfo = {
			{
				"淫荡寺",
				"level1",
				0,
				400,
			},
			{
				"第二关 ",
				"level2",
				200,
				500,
			},
			{
				"第三关",
				"level3",
				0,
				600,
			},
			{
				"第四关",
				"level4",
				300,
				630,
			},
			{
				"第五关",
				"level5",
				0,
				780,
			}}
		local temp
		--创建关卡，并将未解锁的关卡禁用
		for i,v in pairs(gradeInfo) do
			temp = KNButton:new("mission/"..v[2],0,v[3],v[4],function() end)
			if i > 1 then
				temp:setEnabledLua(false)
			end
			layer:addChild(temp)
		end
	end
	initGrade()
	return layer
end
