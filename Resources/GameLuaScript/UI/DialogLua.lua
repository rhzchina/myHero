--[[
	功能：创建对话框
	参数bgimg，背景图片
	参数point_x,对话框的坐标位置
	参数point_y,对话框的y坐标位置
]]--
local dialog
function creatDialog(point_x,point_y)
	dialog = CCMenu:create()
	--dialog:setPosition(point_x,point_y)
	return dialog
end

function addDialog(child)
	dialog:addChild(child)
end

--[[
--功能：创建对话框背景
--参数：bgimg，背景图片
--参数：point_x，x坐标
--参数：point_y，y坐标
]]--
function creatDialog(bgimg,point_x,point_y)
	--创建背景	
	local menuPopupItem = CCMenuItemImage:create(bgimg,bgimg)
    menuPopupItem:setPosition(0, 0)
    menuPopup = CCMenu:createWithItem(menuPopupItem)
    menuPopup:setPosition(point_x,point_y)
	return menuPopup
end

--[[
--功能：创建文本信息
--参数：labelName，文本内容
--参数：LPoint_x，x坐标
--参数：LPoint_y，y坐标
--参数：fontsize，字体大小
--参数：color_R，color_B,color_G,颜色值
]]--
function creatlabe(labelName,LPoint_x,LPoint_y,fontsize,color_R,color_B,color_G)
	local testLabel = CCLabelTTF:create(labelName, "Arial", fontsize)
	testLabel:setColor( ccc3(color_R,color_B,color_G))
    local testMenuItem = CCMenuItemLabel:create(testLabel)
	testMenuItem:setPosition(LPoint_x,LPoint_y)
	return testMenuItem
end