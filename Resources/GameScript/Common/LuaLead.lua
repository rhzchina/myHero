--[[

新手引导

]]

local LuaLead = {}

local step = 0
local clicked = false
local guideLayer = nil

function LuaLead:show( layer , params )
	params = params or {}

	local btn_width = params.width or layer:getContentSize().width
	local btn_height = params.height or layer:getContentSize().height
	local btn_x = params.x or layer:getPositionX()
	local btn_y = params.y or layer:getPositionY()
	local guide = nil

	if btn_x < 0 and params.selectList then
		btn_x = btn_x + 464
	end

	if params.offset_width then btn_width = btn_width + params.offset_width end
	if params.offset_height then btn_height = btn_height + params.offset_height end
	if params.offset_x then btn_x = btn_x + params.offset_x end
	if params.offset_y then btn_y = btn_y + params.offset_y end

	print("show [Guide] " .. step .. " , width: " .. btn_width .. " , height: " .. btn_height .. " , x: " .. btn_x .. " , btn_y: " .. btn_y)

	local handle = nil
	local render = function()
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(handle)
		handle = nil


		local cur_scene = display.getRunningScene()
		if cur_scene:getChildByTag("899") then
			cur_scene:removeChild(guideLayer , true)
		end

		guideLayer = GameLead:createSprite()

		clicked = false
		guideLayer:show(btn_width , btn_height , ccp(btn_x , btn_y) , 0.4 , function()
			if clicked == true then return end
			clicked = true

			step = step + 1

			if params.callback ~= nil then
				params.callback()
			end

			if params.remove ~= nil then
				cur_scene:removeChild(guideLayer , true)
			end
		end , function()
			if params.mask_clickable ~= nil then
				if clicked == true then return end
				clicked = true

				step = step + 1

				if params.callback ~= nil then
					params.callback()
				end

				if params.remove ~= nil then
					cur_scene:removeChild(guideLayer , true)
				end
			end
		end)
		
	
--
--		-- 对话
--		if Config_Guidetalk[step .. ""] then
--			local config = Config_Guidetalk[step .. ""]
--			if config ~= nil then
--				local dialog_height = 300
--				local offset_y = btn_y - dialog_height - 20
--				if offset_y < 10 then
--					offset_y = btn_y + btn_height + 150
--				end
--
--
--
--
--				local guide_logo = display.newSprite(IMG_PATH .. "image/common/guide_logo.png")
--				setAnchPos(guide_logo , 240 , offset_y - 8)
--				guideLayer:addChild(guide_logo)
--
--				-- 文字
--				local text = display.strokeLabel( config["text"] , 25 , 15 + offset_y , 18 , ccc3( 0xff , 0xff , 0xff ) , -1 , ccc3( 0xa7 , 0xe1 , 0xe6 ) , {
--					dimensions_width = 212,
--					dimensions_height = 125,
--					align = 0,
--				})
--				guideLayer:addChild(text)
--
--				-- tips
--				if config["tips"] then
--					local tips = display.strokeLabel( config["tips"] , 25 , 15 + offset_y , 18 , ccc3( 0xff , 0xff , 0x00 ) ) --					guideLayer:addChild(tips)
--				end
--			end
--		end
		
		local dialog_bg = newSprite(IMG_SCENE .. "guide/dialog_bg.png")
		setAnchPos(dialog_bg , 240 , params.offsetY or 0,0.5)
		guideLayer:addChild(dialog_bg)
	
		local guider = newSprite(IMG_SCENE.."guide/secretary.png")
		setAnchPos(guider,10, (params.offsetY or 0) + dialog_bg:getContentSize().height - 20 )
		guideLayer:addChild(guider)
		
	
		local text = newLabel(getConfig("guide", step.."", "desc"), 30, {color = ccc3(0, 0, 0), width = dialog_bg:getContentSize().width - 60})
		
		setAnchPos(text, 240,  (params.offsetY or 0) + dialog_bg:getContentSize().height / 2, 0.5, 0.5)
		guideLayer:addChild(text)
		
--		-- 箭头
		local arrow = display.newSprite(IMG_SCENE .. "guide/arrow.png")
		setAnchPos(arrow , btn_x + btn_width / 2 , btn_y + btn_height + 2 , 0.5)
		guideLayer:addChild(arrow)
--
		local arrowAction = nil
		arrowAction = function()
			transition.moveBy(arrow , {
				delay = 0.1,
				y = 40,
				time = 0.3,
				onComplete = function()
					transition.moveBy(arrow , {
						y = -40,
						time = 0.5,
						onComplete = arrowAction
					})
				end
			})
			
		end
		arrowAction()

		guideLayer:setTag("899")
		cur_scene:addChild(guideLayer , 100)
	end
	handle = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(render , 0.02 , false)
end


function LuaLead:getStep()
	return step
end


function LuaLead:setStep( num )
	if num == nil then return false end
	step = tonumber( num )
end


return LuaLead
