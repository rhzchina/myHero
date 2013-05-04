--[[

消息框

]]

KNMsg = {}

function KNMsg:new()
	local store = nil

	return function(self)
		if store then return store end

		local o = {}
		setmetatable(o , self)
--		self._index=self

		store = o
		store.text = ""
		store.isAction = false    --是否有动画在执行
		
		local KNMask = require("GameScript/Common/KNMask")
		local mask = nil
		
		--检查及初始化参数
		local function checkData(str , param)
			store.text = str or ""
			-- 如果提示文字 为空  则不执行本次提示
			if(store.text == "") then
				return 0
			end
			-- 动画是否在执行中，如果执行中则不执行新动画
			if(store.isAction) then
				return 0
			end
			-- 初始化动画执行时间
			local time = 1
			if args ~= nil then
				time = args.time or 1
			end
			
			return time , param
		end

		-- 创建 对应UI布局
		local function createLayout(type , args)
			local content = nil
			local textField = CCLabelTTF:create(store.text , "Arial" , 15)
			
			if type == 0 then --Error
				content = CCSprite:create(IMG_COMMON .. "prompt_bg.png")
				content:setAnchorPoint( ccp(0 , 1) )
				
				content:addChild(textField)
			elseif type == 1 then--带按钮的提示框
				content = CCSprite:create(IMG_COMMON .. "tip_bg.png")
				content:setAnchorPoint( ccp(0 , 1) )
				
				local cSize = content:getContentSize()
				
				local isCancel = false--是否存在 取消 回调
				local isConfirm = false--是否存在 确定 回调
				
				if args ~= nil then
					isCancel = isset(args , "cancelFun")
					isConfirm = isset(args , "confirmFun")
				end

				local function backFun(type , param)
					if type == 1 and isConfirm then
						args.confirmFun()
					end
					if type == 2 and isCancel then
						args.cancelFun()
					end
					
					mask:remove()--移除msak
					content:setVisible(false)
					content:removeFromParentAndCleanup(true)	-- 清除自己
					store.isAction = false
				end
				local confirmBtn , confirmBtnSize , cancelBtn , cancelBtnSize=nil
				if isConfirm then
					confirmBtn , confirmBtnSize = KNButton:new("red" , "确定" , 0 , 0 , backFun , 1 , 1)
					confirmBtn:setAnchorPoint( ccp(0 , 1) )
					content:addChild(confirmBtn)
				end
							
				--如果有取消时按钮
				if isCancel then
					cancelBtn , cancelBtnSize = KNButton:new("red" , "取消" , 0 , 0 , backFun , 2 , 2)
					cancelBtn:setAnchorPoint( ccp(0 , 1) )
					content:addChild(cancelBtn)
				end
				
				--按钮位置计算
				if isConfirm and isCancel then--如果两个按钮同时存在的坐标设置 
					--重新设置确定按钮坐标
					confirmBtn:setPosition(ccp((content.x + cSize.width/2 - confirmBtnSize.width) / 2 , content.y + confirmBtnSize.height + 30 ))
					confirmBtn:setHandlerPriorityLua(-130)
					cancelBtn:setPosition(ccp((content.x + cSize.width + cancelBtnSize.width / 2) / 2 , content.y + cancelBtnSize.height + 30 ))
					cancelBtn:setHandlerPriorityLua(-130)
				else
					if isConfirm then--如果只有确认按钮时的坐标
						confirmBtn:setPosition(ccp((content.x + cSize.width - confirmBtnSize.width) / 2 , content.y + confirmBtnSize.height + 30 ))
						confirmBtn:setHandlerPriorityLua(-130)
					elseif isCancel then--如果只有取消按钮时的坐标
						cancelBtn:setPosition(ccp((content.x + cSize.width - cancelBtnSize.width) / 2 , content.y + cancelBtnSize.height + 30 ))
						cancelBtn:setHandlerPriorityLua(-130)
					end
				end
				

				content:addChild(textField)
			end
			
			local tempX = ( display.width - content:getContentSize().width ) / 2
			local tempY = ( display.height + content:getContentSize().height / 2 ) / 2
			content:setPosition( ccp( tempX , tempY ) )
			
			textField:setAnchorPoint( ccp( 0 , 1 ) )
			textField:setColor( ccc3(0 , 0 , 0) ) 
			textField:setPosition( ccp( ( content:getContentSize().width - textField:getContentSize().width ) / 2 , content:getContentSize().height / 1.5 ) )
			return content,textField
		end 
		
		-- 执行动画效果
		local function createAction(target , time , type , args)
			local scene = display.getRunningScene()
			
			local showTime = time  -- 动画效果总时间
			local startEfTime = showTime / 3  -- 显示前渐变动画效果时间
			local endEfTime = showTime / 3  -- 消失时渐变动画时间
			
			store.isAction = true
			if type == 0 then  -- 无遮罩，展示后消失
			 	scene:addChild(target)

				-- 渐变显示
				transition.fadeIn(target , {
					time = startEfTime,
				})

				-- 显示动画
				transition.moveTo(target , {
					onStart = function() end,
					y = target.y + 100,
					time = showTime,
					onComplete = function()
						target:setVisible(false)
						target:removeFromParentAndCleanup(true)	-- 清除自己
						store.isAction = false
					end
				})

				-- 消失动画
				transition.fadeOut(target , {
					time = endEfTime,
					delay = showTime - endEfTime,
				})
			elseif type == 1 then  -- 有遮罩，显示后存在于屏幕上，等待操作
				--渐变显示
				mask = KNMask.new({item = target})
				scene:addChild(mask)
				
				transition.fadeIn(target , {
					time = startEfTime,
				})

				-- 显示动画
				transition.moveTo(target , {
					y = target.y + 100,
					time = showTime,
				})
			end
		end
		--单纯文字展示
		function store:textShow(str , args)
			local time , args = checkData(str,args)
			if time == 0 then return end
			
			local textField = CCLabelTTF:create(store.text , "Arial" , 15)
			textField:setAnchorPoint( ccp(0 , 1) )
			local tempX = (display.width - textField:getContentSize().width ) / 2
			local tempY = (display.height + textField:getContentSize().height / 2 ) / 2
			textField:setPosition( ccp(tempX , tempY) )
			createAction(textField , time , 0)
		end

		-- 闪现
		function store:flashShow(str , args)
			local time , args = checkData(str , args)
			if time == 0 then return end
			-- 生成显示对像
			local tempContent , textField = createLayout(0)
			-- 设置文字
			textField:setString(store.text)
			-- 执行动画
			createAction(tempContent , time , 0)
		end
		
		
		--有确认 提示框
		function store:boxShow(str , args)
			--[[args={confirmFun=function,和cancelFun=function}
				（1）调用boxShow方法，显示对像在创建时会判断confirmFun和cancelFun是否存，存在则创建，否则不创建
				（2）confifmFun和cancelFun同时存在则创建两个按钮，如果只存在两个中的一个，则创建对应的确定或取消按钮
				（3）按钮的位置自动生成
			]]--
			local time , args = checkData(str , args)
			if time == 0 then return end

			--生成显示对像
			local tempContent , textField = createLayout( 1 , args )
			--设置文字
			textField:setString(store.text)
			--执行动画
			createAction(tempContent , time , 1)
		end
		
		-- 设置文字
		function store:setText(args)
			store.text = args
		end

		-- 返回文字
		function store:getText()
			print(store.text)
		end


		return o
	end
end


KNMsg.getInstance = KNMsg:new()
