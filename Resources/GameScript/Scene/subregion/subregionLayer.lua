local PATH = IMG_SCENE.."login/"
local subregionLayer = {
	layer,
	shopLayer,
	selectLayer,
	select_server
}

function subregionLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	this.select_server = DATA_CommonUser:get_server().area
	local params = data or {}
	this.layer = newLayer()
	local bg = newSprite(PATH.."login_bg.jpg")
	this.layer:addChild(bg)
	
	local logo = newSprite(PATH.."logo.png")
	setAnchPos(logo, 240, 750, 0.5, 0.5)
	this.layer:addChild(logo)
	
	local font = newSprite(PATH.."font.png")
	setAnchPos(font, 240, 640, 0.5, 0.5)
	this.layer:addChild(font)
	
	this:show()
	
	return this
end

function subregionLayer:show()
	if self.shopLayer then
		self.layer:removeChild(self.shopLayer,true)
	end
	if self.selectLayer then
		self.layer:removeChild(self.selectLayer,true)
	end
	
	self.shopLayer = CCLayer:create()
	
	local input_bg = newSprite(PATH.."input_bg.png")
	setAnchPos(input_bg, 240, 350, 0.5, 0.5)
	self.shopLayer:addChild(input_bg)
	
	local input_font = newSprite(PATH.."s_"..self.select_server..".png")
	setAnchPos(input_font, 240, 350, 0.5, 0.5)
	self.shopLayer:addChild(input_font)
	
	
	
	local strat_game = Btn:new(IMG_BTN,{"start_game.png", "start_game_press.png"},140,200,{
				callback = 
				function()
					CONFIG_HTTP_URL = "http://ztczs.com:4755/"
					HTTPS:send("User" , {m="init",a="init",init = "checkup",area = self.select_server} )
				end})
	self.shopLayer:addChild(strat_game:getLayer())
			
	local server_list = Btn:new(IMG_BTN,{"server_select.png", "server_select_press.png"},130,100,{
				callback = 
				function()
					self:select()
				end})
	self.shopLayer:addChild(server_list:getLayer())
	self.layer:addChild(self.shopLayer)
end

function subregionLayer:select()
	if self.shopLayer then
		self.layer:removeChild(self.shopLayer,true)
	end
	if self.selectLayer then
		self.layer:removeChild(self.selectLayer,true)
	end
	self.selectLayer = CCLayer:create()
	
	local login_text = newSprite(IMG_TEXT.."login_text.png")
	setAnchPos(login_text, 240, 510, 0.5, 0.5)
	self.selectLayer:addChild(login_text)
	
	
	local input_font = Btn:new(PATH,{"input_bg.png"},110,430,{
				other = {PATH.."s_"..DATA_CommonUser:get_server().area..".png",115,27},
				callback = 
				function()
					self:show()
				end})
	self.selectLayer:addChild(input_font:getLayer())
	
	local scroll = ScrollView:new(110,0,480,430,10,false)
	local temp
	for k,v in pairs(DATA_CommonUser:get_other()) do
		print(v.area)
		temp = Btn:new(PATH,{"input_bg.png"},0,0,{
				other = {PATH.."w_"..v.area..".png",115,27},
				callback = 
				function()
					self.select_server = v.area
					self:show()
				end})
		scroll:addChild(temp:getLayer(),temp)
	end
	self.selectLayer:addChild(scroll:getLayer())
		
	self.layer:addChild(self.selectLayer)
end

function subregionLayer:getLayer()
	return self.layer
end

function subregionLayer:getRange()
	local x = self.layer:getPositionX()
	local y = self.layer:getPositionY()
--	if self.params["parent"] then
--		x = x + self.params["parent"]:getX() + self.params["parent"]:getOffsetX()
--		y = y + self.params["parent"]:getY() + self.params["parent"]:getOffsetY()
--	end
	local parent = self.layer:getParent()
	x = x + parent:getPositionX()
	y = y + parent:getPositionY()
	while parent:getParent() do
		parent = parent:getParent()
		x = x + parent:getPositionX()
		y = y + parent:getPositionY()		
	end
	return CCRectMake(x,y,self.layer:getContentSize().width,self.layer:getContentSize().height)
end

return subregionLayer
