--@name GM-VoTV Full System
--@author Gooch
--@shared
--@superuser

--[[ THE VoTV Project Description ]
        
    ----------------------------------------------------------------
    . ...##..######....#######...#######..##........##.....##.##.. .
    . ..##..##....##..##.....##.##.....##.##....##..##.....##..##. .
    . .##...##........##.....##.##.....##.##....##..##.....##...## .
    . ##....##...####.##.....##.##.....##.##....##..#########....##.
    . .##...##....##..##.....##.##.....##.#########.##.....##...## .
    . ..##..##....##..##.....##.##.....##.......##..##.....##..##. .
    . ...##..######....#######...#######........##..##.....##.##.. .
    ----------------------------------------------------------------
    
    [<14. 05. 2026>]    The GM-VoTV Project was orginally created and planned since June 2025.
    By technical reasons, the project had to go to secon plan and became temporarely paused.
    GM-VoTV has been recreated more than 3 times an was growing and growing by coding grammar.
    
    [<14. 05. 2026>]    Project is revived now and now the work on it is resumed too. The speed of development is
    quite slow right now by same technical reasons but now have potential and "ability" to work on it. 
    Message to self in future: Don't Give Up!
        
--]]

    local b64d = http.base64Decode
    
    local NotifyMSGs =
    {
        NOT_HUNGRY = b64d("0K8g0L3QtSDRhdC+0YfRgyDQtdGB0YLRjA=="),
        NOT_TIRED = b64d("0K8g0L3QtSDRhdC+0YfRgyDRgdC/0LDRgtGM"),
        TOO_TIRED_RUN = b64d("0K8g0YHQu9C40YjQutC+0Lwg0YPRgdGC0LDQuywg0YfRgtC+0LHRiyDQsdC10LbQsNGC0Yw="),
        TOO_TIRED_INJ = b64d("0K8g0YHQu9C40YjQutC+0Lwg0YDQsNC90LXQvSwg0YfRgtC+0LHRiyDQsdC10LbQsNGC0Yw="),
        DONT_WANT_TO = b64d("0K8g0L3QtSDRhdC+0YfRgyDRjdGC0L4g0YHQtdC50YfQsNGB")
    }

if SERVER then
    
    if game.isSinglePlayer() == true then throw("[GM-VoTV] Chip wouldn't work on Singleplayer! Please open the server to start the GM-VoTV") return end
    
    local GM_V_funcs = {}
        GM_V_funcs.allPls = find.allPlayers
    
    local GM_V_const = {}
        GM_V_const.ent_entity_chip            = chip()
        GM_V_const.ent_player_owner           = GM_V_const.ent_entity_chip:getOwner()
        GM_V_const.num_players                = #( find.allPlayers() )
    
    pls_count = 0
            
    net.receive("GMV_hotCheck_PLAYERCOUNT", function()
        
        pls_count = pls_count + 1
        
        net.start("GMV_reverseCheck_OWNER_DEBUG")
        net.writeFloat( pls_count )
        net.send( GM_V_const.ent_player_owner )
        
    end)
    
    for _, v in ipairs(find.allPlayers()) do
            
        v.dmgFoot = 0
        v:setJumpPower(160)
        v:setWalkSpeed(160)
        v:setRunSpeed(240 - (v:getHealth() < 20 and 70 or 0))
        v:setCrouchedWalkSpeed(0.6)
        
    end
    
    timer.create("PlayerMovementApply", 3, 0, function()
    
        for _, v in ipairs(find.allPlayers()) do
            
            v:setJumpPower(160 - (v:getHealth() < 20 and 160 or 0))
            v:setWalkSpeed(180 - (v:getHealth() < 20 and 60 or 0) )
            v:setRunSpeed(260 - (v:getHealth() < 20 and 140 or 0) )
            v:setCrouchedWalkSpeed( 0.6 - (v:getHealth() < 20 and 0.2 or 0) )
            
            if v.stamina ~= nil then
                
                if v.stamina < 15 then
                    
                    v:setRunSpeed(210 - (v:getHealth() < 20 and 60 or 0) )
                    
                end
                
            end
            
            if v:getHealth() < 20 and v:getHealth() > -1 then
                
                net.start("PLAYER_INJURED")
                net.writeVector( v:getPos() )
                net.send()
                
            end
            
        end
    
    end)
    
    hook.add("PlayerHurt", "", function(ply, attacker, newHealth, damageTaken) 
        
        if isValid( ply ) then net.start("injured") net.writeFloat(damageTaken) net.send(ply) end
            
    end)
    
    local FOOD = 
    {
        {
            name = "MRE",
            model = "models/meercat/mre/mre.mdl",
            power = 4.7,
            times = 4,
            class = "food",
        },   
        
        {
            name = "SHROOM",
            model = "models/meercat/shrooms/shroom1.mdl",
            power = 1.5,
            times = 1,
            class = "food",
        },   
            
        {
            name = "SHROOM2",
            model = "models/meercat/shrooms/shroom2.mdl",
            power = 2,
            times = 1,
            class = "food",
        },
        
        {
            name = "SHROOM3",
            model = "models/meercat/shrooms/shroom3.mdl",
            power = 2.5,
            times = 1,
            class = "food",
        },
        
        {
            name = "SHROOM4",
            model = "models/meercat/shrooms/shroom5.mdl",
            power = 4,
            times = 1,
            class = "food",
        },
        
        {
            name = "SHROOM5",
            model = "models/meercat/shrooms/shroom6.mdl",
            power = 1,
            times = 2,
            class = "food",
        },
        
        {
            name = "flash_battery",
            model = "models/meercat/batteries/batteries1.mdl",
            power = 100,
            times = 100,
            class = "battery"
        },
        
        {
            name = "redbull",
            model = "models/foodnhouseholditems/sodacanc01.mdl",
            power = 3.3,
            times = 1,
            class = "energy_drink"
        }
    }
    
    hook.add("PlayerSay", "MAIN_COMMAND_HOOK", function(ply, text, teamChat) 
        
        if ply == GM_V_const.ent_player_owner then
            
            local msg_split = string.split(text," ")
            
            if msg_split[1] == "-mn" then
                
                local number = tonumber( msg_split[2] )
                local reason = table.concat( msg_split , " ", 3, #msg_split)
                if not isnumber(number) then return end
                
                net.start("MONEY_MANUAL_GIVING")
                net.writeTable( {number, reason} )
                net.send()
                
                net.start("GAME_MONEY_upd")
                net.writeFloat( number )
                net.send()    
            
            end
            
            if text == "~manipulator" then GM_V_const.ent_player_owner:setPos(Vector(0,0,10000)) end
            
        end
            
    end)
    
    local function findFoodInTable( mdl_name )

        for _, v in ipairs(FOOD) do
            
            if v.model == mdl_name then 
                
                return  v.times, v.power, v.class 
                
            end
             
        end
        
        return 0, 0, ""
        
    end
    
    local function addStaminaManual( pl, num )
        
        if not isValid( pl ) or not pl:isPlayer() then return end
            
        net.start("STAMINA_SV_CHANGE")
        net.writeFloat( num )
        net.send( pl )
        
    end
    
    local function sendNotification( pl, str, type )
        
        if not isValid( pl ) or not pl:isPlayer() then return end
        
        net.start("NOTIFY")
        net.writeTable( {type, str} )
        net.send( pl )
        
    end
    
    local function addHungerManual( pl, num )
        
        if not isValid( pl ) or not pl:isPlayer() then return end
            
        net.start("HUNGER_SV_CHANGE")
        net.writeFloat( num )
        net.send( pl )
        
    end
    
    net.receive("TO_SERVER_flashlight_off", function()
        
        local ply_id = net.readFloat()
        
        hook.runRemote( nil, {ply_id, "flashlight "} )
        
    end)
    
    net.receive("flashlight_ALLOW", function()
        
        local tbl = net.readTable()
        
        local ply_id = tbl[1]
        local allow  = tbl[2]
        
        hook.runRemote( nil, {ply_id, "flashlight_enable ", allow} )
        
    end)
    
    hook.add("PlayerFootstep", "", function(ply) 
        
        local pl = ply
        
        if pl:getHealth() < 20 and not pl:isCrouching() then
            
            pl.dmgFoot = pl.dmgFoot + 1
            
            if pl.dmgFoot >= 3 then
                 
                pl.dmgFoot = 0
                
                pl:applyDamage(math.random(1,2), game.getWorld(), nil, DAMAGE.CLUB)
                pl:emitSound("physics/flesh/flesh_bloody_impact_hard1.wav", 100, 80)
                --:applyDamage(amt, attacker, inflictor, dmgtype, pos)
                
                sendNotification( pl, NotifyMSGs.TOO_TIRED_INJ, 1 )
                
            end
            
        end
        
    end)
    
    local function UpdateUsables()
        
        local ents = find.all()
        
        for _, ent in ipairs(ents) do
            
            if not isValid(ent) then continue end
            
            if ent.uniqueClass ~= nil then continue end --Leaving that as "return" would left new spawned entities without subparameters.

            
            local mdl = ent:getModel()
            local times, power, vclass = findFoodInTable(mdl)
            
            if times ~= 0 then
                
                ent.times = times
                ent.maxtimes = times
                ent.power = power
                ent.uniqueClass = "usable"
                ent.usableType = vclass
                
            end
            
        end
        
    end

    UpdateUsables()
    
	local pendingEntities = {}

	hook.add("OnEntityCreated", "", function(ent)

		if not isValid(ent) then return end
		table.insert(pendingEntities, ent:entIndex())

	end)

	timer.create("ProcessPendingEntities", 0.1, 0, function()

		if #pendingEntities == 0 then return end
		
		local processed = 0

		for i = #pendingEntities, 1, -1 do

			local ent = entity(pendingEntities[i])

			if isValid(ent) then

				local mdl = ent:getModel()
				local times, power, vclass = findFoodInTable(mdl)
				if times ~= 0 then
					ent.times = times
					ent.maxtimes = times
					ent.power = power
					ent.uniqueClass = "usable"
					ent.usableType = vclass
				end

			end

			table.remove(pendingEntities, i)
			processed = processed + 1

			if processed >= 50 then break end
		end

	end)
    
    local data = {}
    
    timer.create("_food_Cycle", 0.35, 0, function()
        
        local players = find.allPlayers()
        
        for _, v in ipairs(players) do
            if not isValid(v) then continue end
            
            local ae = v:getEyeTrace().Entity
            local times, power, vclass = 0, 0, nil
            
            if isValid(ae) then
                times = ae.times or 0
                power = ae.power or 0
                //     times/power,   
                if times == 0 then
                    times, power, vclass = findFoodInTable(ae:getModel())
                else
                    vclass = ae.usableType or "food"
                end
            end
            
            local data = {
                ae,
                isValid(ae) and ae:getPos():getDistance(v:getPos()) or 0,
                isValid(ae) and ae:getModel() or "unknown",
                times,
                power,
                isValid(ae) and ae:getPos() or Vector(0),
                isValid(ae) and tostring(ae:entIndex()) or "0",
                findFoodInTable(isValid(ae) and ae:getModel() or ""),
                vclass,
                maxtimes
            }
            
            net.start("food_net")
            net.writeTable(data)
            net.send(v)
            
        end
        
    end)
        
	--[[
        
        net.start("sv_stats_Update")
        net.writeTable({LOCAL_Hunger,LOCAL_Stamina,GAME_FLASHLIGHT})
        net.writeEntity( player() )

	]]

    net.receive("sv_stats_Update",function()
        
        local tbl = net.readTable()

		local hunger,stam,flash = tbl[1],tbl[2],tbl[3]

        local pl = net.readEntity()
        
        pl.food = hunger
        pl.stamina = stam
		      pl.flashlight = flash

    end)

    net.receive("_use", function()
        
        local netstr = net.readInt(32)
        local pl = net.readEntity()
        
        local n_entID = tonumber( netstr ) 
        
        local n_bitenEnt = entity(n_entID)
        
        if not isValid( n_bitenEnt ) then return end
        
        n_bitenEnt:setFrozen( true )
        if timer.exists("unfreeze") then timer.remove("unfreeze") else timer.create("ent_unfreeze",0.1,0,function() if isValid( n_bitenEnt ) then n_bitenEnt:setFrozen(false) timer.remove("ent_unfreeze") end end) end
        
        if n_bitenEnt.times ~= nil then
            
            if n_bitenEnt.usableType == "food" then
            
                if pl.food < 90 then    
                                    
                    n_bitenEnt.times = n_bitenEnt.times - 1
                    n_bitenEnt:emitSound( "physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav",100,100 )
                    addHungerManual( pl, n_bitenEnt.power )
                        
                    if n_bitenEnt.times <= 0 then n_bitenEnt:remove() end
                        
                else
                
                    sendNotification( pl, NotifyMSGs.NOT_HUNGRY, 3 )
                
                end
                
            elseif n_bitenEnt.usableType == "battery" then
                
                local currentCharge = n_bitenEnt.power 
            				local playerCharge = pl.flashlight
            
            				net.start("flashlight_MANUAL_UPDATE")
            				net.writeFloat(currentCharge)
            				net.send( pl )
            
            				n_bitenEnt.power = playerCharge
            				n_bitenEnt.times = playerCharge
            				
            				sendNotification( pl, "Flashlight battery changed: "..currentCharge.."/100.0",3)
                
            elseif n_bitenEnt.usableType == "energy_drink" then
                
                local playerStamina = pl.stamina
                
                if playerStamina < 99.0 then
                    
                    local power = n_bitenEnt.power
                    
                    n_bitenEnt.times = n_bitenEnt.times - 1
                    pl:emitSound( "eating_and_drinking/soda.wav",100,100 )
                    
                    addStaminaManual( pl, power * 2 )
                    
                    timer.create("Recycle",0.1,30,function()
                        
                        if playerStamina < 99.0 then
                            
                            addStaminaManual( pl, power / 6 )
                            addHungerManual( pl, power / 96 )
                            
                        end
                            
                    end)
                    
                    if n_bitenEnt.times <= 0 then n_bitenEnt:remove() end
                    
                else
                    
                    sendNotification( pl, NotifyMSGs.DONT_WANT_TO, 3 )
                    
                end
            
            end
         
        end
        
    end)
    
end

if CLIENT then
    
    if game.isSinglePlayer() == true then throw("[GM-VoTV] Chip wouldn't work on Singleplayer! Please open the server to start the GM-VoTV") return end
    
    local GMVL_own_PlsCount = 0
    local GMVL_own_DrawDebug = true
    local GAME_MONEY = 0
    local LOCAL_Hunger  = 40.0
    local LOCAL_Stamina = 10.0
    local GAME_FLASHLIGHT = 1.2
    local random = math.random
    local HEALTH_ALPHA = 0
    local dmgTKN = 0
    local old_hp = 0
    local random_command = ""
    local id = 0
    local allowed_Flash = true
    local use_type = "hold"
    local injuredPlayers = {}

    net.receive("PLAYER_INJURED", function()
        
        local vec = net.readVector()
        local tbl = { vector=vec, time=2 }
        
        table.forceInsert( injuredPlayers, tbl )
        
    end)
    
    local commands = 
        {
            "~mn -+coin",
            "~manipulator",
            "~shot ply hp",   
        }
    
    local function tip_Command()
        
        id = id + 1
        if id >= #commands then id = 1 end
        
        random_command = commands[ id ]
        
    end    
    
    timer.create("regularUpdating_FS",1,0,function()
        
        net.start("sv_stats_Update")
        net.writeTable({LOCAL_Hunger,LOCAL_Stamina,GAME_FLASHLIGHT})
        net.writeEntity( player() )
        net.send()
            
    end)
    
    net.receive("STAMINA_SV_CHANGE", function() local num = net.readFloat() LOCAL_Stamina = LOCAL_Stamina + num end)
    net.receive("HUNGER_SV_CHANGE", function() local num = net.readFloat() LOCAL_Hunger = LOCAL_Hunger + num end)
    
    tip_Command()
    timer.create("TIP_COMMAND",4,0,tip_Command)
    
    local GM_V_const_CLIENT = {}
        GM_V_const_CLIENT.ent_entity_chip            = chip()
        GM_V_const_CLIENT.ent_player_owner           = GM_V_const_CLIENT.ent_entity_chip:getOwner()
    
    local GAME_hungerCounter = 0
    local GAME_staminaCounter = 0
    local aim_entity_data = {}
    
    net.receive("GAME_MONEY_upd",function()
        
        local subc = net.readFloat()
        
        GAME_MONEY = GAME_MONEY + subc
        
    end)
    
    local print_funcs = {}
    
    print_funcs.Default = function(...)
       
        print(Color(255,255,0),"[",Color(0,100,255),"GM-VoTV",Color(255,255,0),"] ",Color(255,255,255),...)
        player():emitSound("common/bass.wav",100,255)
        
    end
    
    print_funcs.InGame = function(...)
       
        print(Color(105,255,0),"[",Color(0,180,0),"GM-VoTV",Color(105,255,0),"] ",Color(255,255,255),...)
        --player():emitSound("common/wpn_denyselect.wav",100,100)
        
    end
    
    timer.simple(0, function()
    
        net.start("GMV_hotCheck_PLAYERCOUNT")
        net.send()
    
    end)
        
    net.receive("GMV_reverseCheck_OWNER_DEBUG", function()
        
        GMVL_own_PlsCount = net.readFloat()
        
    end)
    
    hook.add("InputPressed", "", function(button) 
        
        if button == KEY.E and not input.isKeyDown(KEY.CTRL) then
            
            if aim_entity_data[7] ~= 0 and aim_entity_data[7] ~= "0" then
                
                if use_type == "use" then
                        
                    net.start("_use")
                    net.writeInt(tonumber(aim_entity_data[7]), 32)
                    net.writeEntity( player() )
                    net.send()
                    
                end
                    
            end
            
        elseif input.isKeyDown(KEY.CTRL) and button == KEY.E then
            
            USE_TYPE_BOOL = !USE_TYPE_BOOL
            use_type = USE_TYPE_BOOL == true and "use" or "hold"
            
        end
        
        if button == KEY.SHIFT then
            
            if LOCAL_Stamina < 15 then
                
                notification.addLegacy(NotifyMSGs.TOO_TIRED_RUN, NOTIFY.HINT, 4)
                
            end
            
        end
            
    end)
    
    net.receive("MONEY_MANUAL_GIVING",function()
    
        local tbl_Net = net.readTable()
        
        local net_num = tbl_Net[1]
        local net_res = tbl_Net[2]
        
        local str1 = (net_num < 0 and "Revoken" or "Given")
        local col1 = (net_num < 0 and Color(200,50,50) or Color(50,200,50) )
        
        print_funcs.InGame(str1,col1," ",tostring(net_num)," points ",Color(255,255,255),"from game balance. ",Color(200,200,50),"Reason: "..tostring(net_res))
        player():emitSound("friends/message.wav",100,100)
        
    end)
    
    net.receive("NOTIFY", function()
        
        local tbl = net.readTable()
        
        local type = tbl[1]
        local msg = tbl[2]
        
        notification.addLegacy(msg, type, 5 + math.clamp(string.len(msg)*0.1, 0, 7))
        
        if type == NOTIFY.UNDO then
            
            player():emitSound("garrysmod/content_downloaded.wav",100,100)    
            
        elseif type == NOTIFY.HINT then
            
            player():emitSound("buttons/blip1.wav",100,100)
            
        elseif type == NOTIFY.ERROR then
            
            player():emitSound("resource/warning.wav", 100, 100)
            
        elseif type == NOTIFY.GENERIC then
            
            player():emitSound("ui/buttonclick.wav",100,100)
            
        elseif type == NOTIFY.CLEANUP then
            
            player():emitSound("garrysmod/content_downloaded.wav",100,100)
            
        end
        
    end)
    
	net.receive("flashlight_MANUAL_UPDATE",function()

		local float = net.readFloat()

		GAME_FLASHLIGHT = float
	
	end)

    net.receive("food_net", function()
        
        aim_entity_data = net.readTable()
        
        --[[
        
            local data = {}
            data.ent = v:getEyeTrace().Entity
            data.ent_dist = (isValid(data.ent) and (data.ent:getPos():getDistance( v:getPos() )) or 0)
            data.ent_mdl = ( isValid(data.ent) and (data.ent:getModel()) or "0") )
            data.ent_times = ( isValid(data.ent) and ( findFoodInTable(data.ent_mdl)[1] ) or "0" )
            data.ent_power = ( isValid(data.ent) and ( findFoodInTable(data.ent_mdl)[2] ) or "0" )
            data.ent_wpos = ( isValid(data.ent) and (data.ent:getPos()) or 0 )
            
        --]]
        
        --printMessage(2, tostring( aim_entity_data[7] ) )
        
    end)
    
    hook.add("PlayerChat", "", function(ply, txt)
        
        if ply == chip():getOwner() and txt == "-debug" then

            GMVL_own_DrawDebug = !GMVL_own_DrawDebug
            print_funcs.Default(Color(255,50,50),"[ADMIN/DEBUG]",Color(255,255,255)," ",tostring(chip():getOwner()).." has turned "..((GMVL_own_DrawDebug == true ) and "ON" or "OFF").." theirs debug mode.")
            
        end
        
    end) 
    
    local function turnOffFLASH()
        
        net.start("TO_SERVER_flashlight_off")
        net.writeFloat( player():entIndex() )
        net.send()
        
    end
    
    local function allowFlash(on)
        
        net.start("flashlight_ALLOW")
        net.writeTable( {player():entIndex(), on} )
        net.send()
        
    end
    
    timer.create("client_cycle", 0.1, 0, function()
        
        if player():isFlashlightOn() then 
           
            GAME_FLASHLIGHT = GAME_FLASHLIGHT - 0.023
            
            if GAME_FLASHLIGHT < 0.05 then 
                
                turnOffFLASH()
                    
                allowFlash(0)
                allowed_Flash = false
        
            else
                
                if allowed_Flash == false then allowed_Flash = true allowFlash( 1 ) end
                
            end
            
        end
        
        if #injuredPlayers >= 1 then 
            
            for _ , v in ipairs(injuredPlayers) do
                
                if v.time > 0 then v.time = v.time - 0.1 else table.removeByValue( injuredPlayers, v ) end
                
            end
            
        end 
            
        if GAME_staminaCounter < 100 then
            
            GAME_staminaCounter = math.clamp(GAME_staminaCounter + 1 + (player():isSprinting() and 10 or 0),0.5,100.0)
                
        else GAME_staminaCounter = 0             LOCAL_Stamina = math.clamp(LOCAL_Stamina - 0.1,0.5,100.0) end
        
        if GAME_hungerCounter < 150 then
           
            GAME_hungerCounter = GAME_hungerCounter + 1 + (player():isSprinting() and 1 or 0)
         
        else GAME_hungerCounter = 0             LOCAL_Hunger = LOCAL_Hunger - 0.1 end
        
        if HEALTH_ALPHA > 0 then                 HEALTH_ALPHA = HEALTH_ALPHA - 10 end
        
    end)    
    
    hook.add("OnPlayerJump", "", function(ply, speed) 
        
        if ply == player() then LOCAL_Stamina = LOCAL_Stamina - 0.1 - (player():isSprinting() and 0.1  or 0)end
        
    end)
    
    local b64 = {}
        b64.INJURED = http.base64Decode("0KDQkNCd0JXQnQ==") -- PAHEH
        b64.InjCtrl = http.base64Decode("WyAhINCh0J7QktCV0KIgISBdCtCf0J7Qm9CX0JjQotCVIChDVFJMKSwg0KfQotCe0JHQqyDQodCd0JjQl9CY0KLQrCDQo9Cg0J7QnSDQntCiINCa0KDQntCS0J7QotCV0KfQldCd0JjQrw==") -- press ctrl to no damage
            
    local fonts = {}
        fonts.DEBUG    = render.createFont("CenterPrintText",20,500,true,false,false,true,0,false,0)
        fonts.DEF_vals = render.createFont("x14y24pxHeadUpDaisy",29,500,false,false,false,true,0,true,0)
        
    local colors = {}
        colors.GRN1 = Color(20,160,20)
        colors.GRN2 = Color(80,160,80)
        colors.GRN3 = Color(120,160,120)
        
        colors.BLU1 = Color(20,20,160)
        colors.BLU2 = Color(80,80,160)
        colors.BLU3 = Color(120,120,160)
        
        colors.YLW1 = Color(160,120,20)
        colors.YLW2 = Color(160,120,80)
        colors.YLW3 = Color(160,120,120)
        
        colors.blank = Color(255,255,255)    
        
    net.receive("injured",function()
        
        HEALTH_ALPHA = 255
        dmgTKN = net.readFloat()
        
    end)

	local RNDR = {}
	RNDR.draw_sText = render.drawSimpleText
	RNDR.draw_Text = render.drawText
	RNDR.setFont = render.setFont
	RNDR.setColor = render.setColor
    
    timer.simple(1, function()
    
        hook.add("DrawHUD", "", function() 
               
            local HUD_x, HUD_y = render.getGameResolution()
            local scrW2, scrH2 = HUD_x/2, HUD_y/2
            
            RNDR.setColor( Color(255,255,25, 100) )
            render.drawRect( scrW2-2.5, scrH2-2.5, 5, 5 )  
            
            --render.drawRect(x, y, w, h)
            
            RNDR.setFont( fonts.DEF_vals )
                
                RNDR.setColor(colors.blank)
                    RNDR.draw_sText( (HUD_x * 0.015), (HUD_y * 0.015), tostring(GAME_MONEY) ) 
                    RNDR.draw_sText( (HUD_x * 0.015), (HUD_y * 0.015)+32, "Key E: "..use_type) 
                    
                RNDR.setColor(colors.GRN1)
                    RNDR.draw_sText( (HUD_x * 0.9), (HUD_y * 0.015), "Fl: "..string.format("%.1f", GAME_FLASHLIGHT).."%"  ) 
                    
                RNDR.setColor(colors.BLU2)
                    RNDR.draw_sText( (HUD_x * 0.015), (HUD_y * 0.85)+20, "S: "..string.format("%.1f", LOCAL_Stamina).."%"  ) 
                    
                RNDR.setColor(colors.YLW1)
                    RNDR.draw_sText( (HUD_x * 0.015), (HUD_y * 0.85)-12, "F: "..string.format("%.1f", LOCAL_Hunger).."%"  ) 
                
                RNDR.setColor( Color( math.clamp(player():getHealth() < 20 and math.sin(timer.curtime()*15)*23 or 0 ,0,55) ,0,0, math.clamp( (255 - player():getHealth()*2.5 - (player():getHealth() < 20 and math.sin(timer.curtime()*14)*30 or 0)), 0,190 )) )
                    render.drawRect(0,0,HUD_x,HUD_y)
                
                if HEALTH_ALPHA > 0 then
                    
                    RNDR.setColor(Color(200,50,50,HEALTH_ALPHA))
                    RNDR.draw_Text( HUD_x / 2, HUD_y / 6, "-".. tostring( math.round( dmgTKN, 0 ) ) , TEXT_ALIGN.CENTER)
                     
                end        
                    
            if aim_entity_data[4] ~= 0 then
                
                local ent_dist = aim_entity_data[2]
                local ent_times = aim_entity_data[4]
                local ent_pos = aim_entity_data[6]
                
                local xx1, yy1 = ent_pos:toScreen().x, ent_pos:toScreen().y

                RNDR.setColor( Color(50,50,50) )
                render.drawRectOutline( xx1-38, yy1-38, 80, 80, 3 )                

                RNDR.setColor( Color(255,100,0) )
                render.drawRectOutline( xx1-40, yy1-40, 80, 80, 3 )             
                
                RNDR.draw_Text(xx1 + 60, yy1 - 45, string.format("%.1f",ent_times).."/"..string.format("%.1f",aim_entity_data[8]) )
                
            end
                   
            if #injuredPlayers >= 1 then
                
                for _, v in ipairs( injuredPlayers ) do
                    
                    local vec = v.vector
                    local opac = v.time
                    
                    local vecX, vecY = vec:toScreen().x, vec:toScreen().y
                    
                    RNDR.setColor( Color(255, opac*21, opac*21, math.clamp( opac*127, 0, 255 ) ) )
                    RNDR.draw_Text( vecX, vecY, tostring( b64.INJURED ), TEXT_ALIGN.CENTER )
                    
                end
                
            end
            
            if player():getHealth() < 20 and player():getHealth() > 0 then
                
                RNDR.setColor( Color( 160, 0, 0 , 200) )
                RNDR.draw_Text( HUD_x / 2, HUD_y / 8.5, b64.InjCtrl, TEXT_ALIGN.CENTER )
                
            end
                 
            if player() == chip():getOwner() then
            
                if GMVL_own_DrawDebug == true then
                    
                    RNDR.setFont( fonts.DEBUG )
                    RNDR.setColor( Color( 180, 180, 180 ) )
                    
                    RNDR.draw_sText( HUD_x / 1.3, HUD_y / 1.3 , "Tip: "..tostring(random_command) )
                    
                end
             
            end
                
        end)
    
    end)
    
end
