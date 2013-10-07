local PATH = IMG_SCENE.."mailbox/"


local sendMailLayer = {
	layer,
	account
}

function sendMailLayer:new(data)
	local this = {}
	setmetatable(this,self)
	self.__index  = self
	
	local params = data or {}
	this.layer = newLayer()
	
	local bg = newSprite(IMG_PATH.."images/common/menu_bg.png")
	this.layer:addChild(bg)
	
	local title = newSprite(PATH.."title.png")
	setAnchPos(title, 240, 800, 0.5)
	this.layer:addChild(title)
	
	--for i = 0,2 do
		local title_font = newSprite(PATH.."title_box_2.png")
		setAnchPos(title_font, 240, 734, 0.5)
		this.layer:addChild(title_font)
	--end
	
	local title_font_text = display.strokeLabel("标题",220,744,20)
	this.layer:addChild(title_font_text)
	
	
	this.account = CCTextFieldTTF:textFieldWithPlaceHolder("请输入信息" , "Thonburi" , 28);
--	self.account:setString("")
	--[[设置颜色]]
	this.account:setColor( ccc3(255 , 255 , 0) )
	this.account:setColorSpaceHolder( ccc3(255 , 255 , 0) )

--	display.align(self.account , display.CENTER , display.cx , display.cy + 100)
	setAnchPos(this.account, 240, 600, 0.5)
	this.layer:addChild( this.account )

	

	--[[绑定事件]]
	local onAttachWithIME = true
	this.account:attachWithIME()
	
	
	
	local opt = {
			{"send_m", 10, 23, false, function() 	
				local open_id = this.account:getString()
				print(open_id)
				open_id = string.trim( open_id )
				if open_id == "" then
					MsgBox.create():flashShow("请输入内容")
					return
				end
				
				HTTPS:send("Mail" ,{m="mail",a="mail",mail = "send",title = "标题",content = open_id} ,{success_callback = 
					function()
						HTTPS:send("Mail" ,{m="mail",a="mail",mail = "open"} ,{success_callback = 
							function()
								switchScene("mailbox")
							end })
					end })
					
			end},
			
			{"back_m",238,23,false,function() 
				HTTPS:send("Mail" ,{m="mail",a="mail",mail = "open"} ,{success_callback = 
					function()
						HTTPS:send("Mail" ,{m="mail",a="mail",mail = "open"} ,{success_callback = 
							function()
								switchScene("mailbox")
							end }) 	
				end })
			end}
			}	
			
	local btn = Btn:new(IMG_BTN, {opt[1][1]..".png", opt[1][1].."_press.png"}, opt[1][2], opt[1][3],{callback = opt[1][5]})
	this.layer:addChild(btn:getLayer())
			
	local back_btn = Btn:new(IMG_BTN, {opt[2][1]..".png", opt[2][1].."_press.png"}, opt[2][2], opt[2][3],{callback = opt[2][5]})
	this.layer:addChild(back_btn:getLayer())
	return this
end


function sendMailLayer:getLayer()
	return self.layer
end


return sendMailLayer
