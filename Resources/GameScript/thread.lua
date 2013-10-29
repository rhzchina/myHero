Thread = {
	
}

function Thread:create()
	local scheduler = nil
	local time_back = nil
	local function time_back_function()
			
			if DATA_User:get("back_num") then
				if DATA_User:get("back_num") > 0 then
					DATA_User:setkey("back_num", tonumber(DATA_User:get("back_num")) - 1)
					local mins = math.floor(tonumber(DATA_User:get("back_num"))/60)--分钟
					local second = tonumber(DATA_User:get("back_num"))%60 -- 秒
					local back_the_num = math.floor(mins/2) --可恢复体力值
					if second == 0 and mins%2 == 0 then
						DATA_User:setkey("energy", 50 - back_the_num)
						IS_UPDATA = true
					end
				end
			end
			
			if DATA_Sports:get_time() then
				if DATA_Sports:get_time().time then
					if DATA_Sports:get_time().time > 0 then						
						DATA_Sports:set_time_key("time",DATA_Sports:get_time().time  - 1)
					end
				end
			end
			
			
			if IS_UPDATA == true then
				local cur_scene = display.getRunningScene().name
				if cur_scene == "home" or cur_scene == "chat"  or cur_scene == "athletics"
				   or cur_scene == "roost" or cur_scene == "transcript" or cur_scene == "activity" 
				   or cur_scene == "bag" or cur_scene == "shop" 
				then
					IS_UPDATA = false
					GLOBAL_INFOLAYER:createtop()
				end
				
			end
	end
	
	scheduler = CCDirector:sharedDirector():getScheduler()
	time_back = scheduler:scheduleScriptFunc(time_back_function, 1, false)
end
