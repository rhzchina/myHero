local PATH = IMG_SCENE.."athletics/"

local AthleticsLayer= {
	layer,	
	contentLayer
}
function AthleticsLayer:create()
	local this={}
	setmetatable(this,self)
	self.__index = self

	this.layer = newLayer()
	local bg = newSprite(IMG_COMMON.."main.jpg")
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."role_bg.png")
	setAnchPos(bg, 0, 545)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."result_bg.png")
	setAnchPos(bg, 0, 425)
	this.layer:addChild(bg)
	
	bg = newSprite(PATH.."result_bg.png")
	setAnchPos(bg, 0, 305)
	this.layer:addChild(bg)
	
	
    return this.layer
end

return AthleticsLayer