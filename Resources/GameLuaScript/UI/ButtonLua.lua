function creatDialog()
	--local winSize = CCDirector:sharedDirector():getWinSize()
	--local function menuCallbackClosePopup(x,y)
        -- loop test sound effect
       -- local effectPath = CCFileUtils:sharedFileUtils():fullPathFromRelativePath("effect1.wav")
       -- effectID = SimpleAudioEngine:sharedEngine():playEffect(effectPath)
	  -- print("key the button")
       -- menuPopup:setVisible(true)
    --end
		
	local menuPopupItem = CCMenuItemImage:create("box.jpg","box.jpg")
    menuPopupItem:setPosition(0, 0)
    --menuPopupItem:registerScriptTapHandler(menuCallbackClosePopup)
    menuPopup = CCMenu:createWithItem(menuPopupItem)
	--local point = CCDirector:sharedDirector():convertToGL(ccp(x,y))
	
    menuPopup:setPosition(100,100)
    -- menuPopup:setVisible(false)
	return menuPopup
end

