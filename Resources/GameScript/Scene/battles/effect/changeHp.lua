--[[

血数字变化 (向上漂的数字)

]]


local M = {}

local logic = require("GameScript/Scene/battle/logicLayer")


--[[执行特效]]
function M:run( hero , num , param )
	if type(param) ~= "table" then param = {} end

	if num ~= 0 then
		--local hero_x , hero_y = hero:getPosition()
		--local hero_size = hero:getContentSize()
		--local hero_width = hero_size.width
		--local hero_height = hero_size.height

		local group , group_width = M:_getHpImage( math.abs( num ) , 21 , num > 0)
		display.align(group , display.LEFT_CENTER , hero._cx - (group_width / 2) + 2 , hero._cy + 90)


		--[[特效开始]]
		local delay = 0

		group:setScale(0.3)
		transition.scaleTo(group, {
			delay = delay,
			time = 0.6,
			scale = 1,
			easing = "ELASTICOUT",
		})

		transition.fadeOut(group, {
			delay = delay + 0.8,
			time = 0.4,
			onComplete = function()
				group:removeFromParentAndCleanup(true)	-- 清除自己

				if param.onComplete then param.onComplete() end
				-- print(">>>>>>>>>>>>>>>>>>>>>>>>>> EFFECT [changeHp] is over <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
			end
		})

		-- 添加到 特效层
		logic:getLayer("effect"):addChild( group )

		return true
	else
		if param.onComplete then param.onComplete() end

		return false
	end
end


-- 获取掉血的图片
function M:_getHpImage(count , width , is_green)
	local image_path = "image/battle/normal/hp.png"
	if is_green then
		image_path = "image/battle/normal/hp_green.png"
	end

	local frames = display.newFramesWithImage(image_path , 10)

	local count_str = tostring(count)
	local len = string.len( count_str )

    local sprite = display.newSpriteWithFrame( frames[1] )
    local offset = 0
    local height = sprite:getContentSize().height

    local render = CCRenderTexture:create( width * len , sprite:getContentSize().height )
	render:begin()

    for i = 1 , len do
        local label = string.sub( count_str , i , i )

        local sprite = display.newSpriteWithFrame( frames[label + 1])
        display.align(sprite, display.LEFT_BOTTOM , offset , 0)

        offset = offset + (width or sprite:getContentSize().width)

        sprite:visit()
    end

    render:endToLua()

    local final_sprite = CCSprite:createWithTexture( render:getSprite():getTexture() )
    final_sprite:setFlipY(true)

    return final_sprite , offset , height
end


return M
