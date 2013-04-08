--[[

遮挡层 (模态框)

** Return **
    CCLayerColor

]]

local M = {}

function M.new(args)
	local args = args or {}

	local r = args.r or 0
	local g = args.g or 0
	local b = args.b or 0
	local opacity = args.opacity or 100         -- 透明度
	local priority = args.priority or -129      -- 优先级
	local click = args.click or function() end  -- 点击回调函数
	local item = args.item or nil               -- 额外 addChild 上去的元素


	-- 创建层
	local view = CCLayerColor:create( ccc4(r , g , b , opacity) )
	
	local function onTouch(eventType , x , y)
	    if eventType == CCTOUCHBEGAN then return true end
	    if eventType == CCTOUCHMOVED then return true end

	    if eventType == CCTOUCHENDED then
	        -- 点击回调函数
			click(x , y)
	        return true
	    end

	    return false
	end

	-- 屏蔽点击
	view:setTouchEnabled( true )
	view:registerScriptTouchHandler(onTouch , false , priority , true)


	if item ~= nil then
	    view:addChild(item)
	end

	function view:show()
	    view:setVisible(true)
	end

	function view:hide()
	    view:setVisible(false)
	end

	function view:remove()
	    view:removeFromParentAndCleanup(true)
	end

	-- 设置点击回调函数
	function view:click(func)
		click = func
	end


	return view
end

return M
