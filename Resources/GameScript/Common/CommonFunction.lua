--混合msas生成新精灵
function mixedGraph(originSp,maskSp)
	rt = CCRenderTexture:create(rectWidth, rectHeight)
	maskSp:setAnchorPoint(ccp(0,0))
	originSp:setAnchorPoint(ccp(0,0))
	--[[指定了新来的颜色(source values)如何被运算。九个枚举型被接受使用：
	GL_ZERO, 
	GL_ONE, 
	GL_DST_COLOR,
	GL_ONE_MINUS_DST_COLOR,
	GL_SRC_ALPHA, 
	GL_ONE_MINUS_SRC_ALPHA, 
	GL_DST_ALPHA, 
	GL_ONE_MINUS_DST_ALPHA, 
	GL_SRC_ALPHA_SATURATE.
	
	参数 destfactor:
	指定帧缓冲区的颜色(destination values)如何被运算。八个枚举型被接受使用：
	GL_ZERO, 
	GL_ONE, 
	GL_SRC_COLOR, 
	GL_ONE_MINUS_SRC_COLOR, 
	GL_SRC_ALPHA, 
	GL_ONE_MINUS_SRC_ALPHA, 
	GL_DST_ALPHA,
	GL_ONE_MINUS_DST_ALPHA]]--
	
	blendFunc=ccBlendFunc:new()
	blendFunc.src = 1
	blendFunc.dst = 1
	maskSp:setBlendFunc(blendFunc)
	
	blendFunc.src = 6			-- mask图片的当前alpha值是多少，如果是0（完全透明），那么就显示mask的。如果是1（完全不透明）
	blendFunc.dst = 0				-- maskSprite不可见
	maskSp:setBlendFunc(blendFunc)
	
	
	local org_visit = originSp.visit
	
	function originSp.visit(self)
		glEnable(GL_SCISSOR_TEST)
		glScissor(0, 0, rectWidth, rectHeight)
		org_visit(self)
		glDisable(GL_SCISSOR_TEST);
	end
	rt:begin()
	maskSp:visit()
	originSp:visit()
	rt:endToLua()
	


	
	local retval = CCSprite:createWithTexture(rt:getSprite():getTexture())
	retval:setFlipY(true)--是否翻转
	return retval
end

--[[ 获取所有子节点里的 CCSprite ]]
function getAllSprites( root )
	local sprites = {}

	local function _getAllSprites( _root )
		local childs_num = _root:getChildrenCount()
		if childs_num == 0 then return end

		local childs = _root:getChildren()
		for i = 0 , childs_num - 1 do
			local child = tolua.cast( childs:objectAtIndex(i) , "CCNode")

			if child:getTag() == 102 then
				sprites[#sprites + 1] = tolua.cast( child , "CCSprite")
			end

			_getAllSprites(child)
		end
	end

	_getAllSprites( root )

	return sprites
end

--设置锚点与位置,x,y默认为0，锚点默认为0
function setAnchPos(node,x,y,anX,anY)
	local posX , posY , aX , aY = x or 0 , y or 0 , anX or 0 , anY or 0
	node:setAnchorPoint(ccp(aX,aY))
	node:setPosition(ccp(posX,posY))
end

function getData(type, ...)
	local DATA
	if type == "bag" then
		DATA = DATA_Bag
	end
	return DATA:get(...)
end

function getBag(...)
	return getData("bag",...)
end

function newLayer()
	return CCLayer:create()
end

function newSprite(path, x, y, anchX, anchY)
	local sp 
	if path then
		sp = CCSprite:create(path)
	else
		sp = CCSprite:create()
	end
	setAnchPos(sp, x, y, anchX, anchY)
	return sp
end

function newLabel(str, size, params)
	local p = params or {}
	local font = FONT
	if p.noFont then
		font = "A"
	end

	local label = CCLabelTTF:create(str, font,size)
	--换行设置
	if p.dimensions then
		label:setDimensions(p.dimensions)
	end
	
	--对齐设置
	if p.align then
		label:setHorizontalAlignment(p.align)
	end
	
	setAnchPos(label, p.x, p.y, p.ax, p.ay)
	label:setColor(p.color or ccc3(255, 255, 255))
	

	return label
end

--获取动作序列
function getSequence(...)
	local array = CCArray:create()	
	for i = 1, arg["n"] do
		array:addObject(arg[i])
	end
	return CCSequence:create(array)
end

--获取排序后的table键值
function getSortKey(t, rule)
	local list = {}
	for k, v in pairs(t) do
		table.insert(list, k)
	end
	
	table.sort(list, rule)
	return list	
end