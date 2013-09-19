--[[

登录框

]]
local MAIN = 1
local PATH = IMG_SCENE.."menu/"
local M = {
	baseLayer,
	layer	
}

function M:create( ... )
	local this = {}
	setmetatable(this,self)
	self.__index = self
	
	this.baseLayer = newLayer()
	
	local bg = newSprite(IMG_COMMON.."menu_bg.png")
	setAnchPos(bg, 0, 0)
	this.baseLayer:addChild(bg)
	
	this:createMenu(MAIN)
	return this
end

function M:createMenu(state)
	if self.layer then
		self.baseLayer:removeChild(self.layer, true)
	end
	
	self.layer = newLayer()
	
	if state == MAIN then
		local title = newSprite(IMG_TEXT.."menu.png")
			setAnchPos(title, 240, 800, 0.5)
		self.layer:addChild(title)
		
		local opt = {
			{"menu_back", 300, 5, false, function() popScene() end},
			{"logout", 150, 5},
			{"card", 20,610,true ,function() 
				HTTPS:send("Book", {book = "open", a = "book", m = "book"}, {success_callback = function(data)
					switchScene("illustrations") 
				end})			
			end},
			{"achieve", 170, 610, true,function() MsgBox.create():flashShow("功能尚未开发") end},
			{"message", 330, 610, true,function() HTTPS:send("Mail", {mail = "open", a = "mail", m = "mail"}, {success_callback = function(data)
					switchScene("mailbox")
				end})
				end},
			{"record", 20, 400, true,function() MsgBox.create():flashShow("功能尚未开发") end},
			{"help", 170, 400, true,function() switchScene("help") end},
			{"setting", 330, 400, true,function() switchScene("setting") end}	
		}
		
		for i = 1, #opt do 
			local btn = Btn:new(IMG_BTN, {opt[i][1]..".png", opt[i][1].."_press.png"}, opt[i][2], opt[i][3], {
					other = opt[i][4] and {IMG_TEXT..opt[i][1]..".png", 60, -30},
					callback = opt[i][5],
			})
			self.layer:addChild(btn:getLayer())
		end
	else
	end
	
	self.baseLayer:addChild(self.layer)
end

function M:getLayer()
	return self.baseLayer
end
return M
