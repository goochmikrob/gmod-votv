--@name RADAR Unit GM-VOTV
--@author Lawman
--@shared

if SERVER then
    
end

if CLIENT then

    local font1 = render.createFont("x14y24pxHeadUpDaisy",24,500,true,false,false,false,0,true,0)
    local font2 = render.createFont("x14y24pxHeadUpDaisy",14,500,true,false,false,false,0,true,0)
    local r_ping = 0
    local time = 4
    local cd = false
    local times_C = 500
    
    local function ping()
        
        times_C = times_C + 1
        
        chip():emitSound("npc/combine_gunship/ping_search.wav", 100, 240)
        r_ping = 0
        
    end
    
    ping()
    
    timer.create( "FILLED_CIRCLE", 0.1, 0, function()
        
        if cd == false then
        
        if r_ping <= 192 then r_ping = r_ping + time else if not timer.exists("_") then timer.create("_", 2, 0, function() ping() timer.remove("_") end) end end
            
        end
            
    end)
    
    hook.add("Render", "", function() 
        
        local x,y = render.getResolution()
        
        render.setColor(Color(255,255,255))
        
        render.setFont(font1)
            render.drawText( 5 , 5 , "Radar UNIT:" , TEXT_ALIGN.LEFT)
            
            render.setFont(font2)
                render.drawText( 5, 30, "Working Cycles: ~" .. tostring( times_C ), TEXT_ALIGN.LEFT)
                
        render.drawCircle( x/2, y/2, 192 )
        render.drawRectOutline( 64, 64, 192*2, 192*2, 1 )
        
        render.setColor(Color(255,255,255 - (math.clamp( math.sin(timer.curtime())*55, -55 , 0)) ))
        render.drawSimpleText( 10, y-21, "RADAR SPEED: " .. tostring( (math.round(time /2.3, 2)) ).." px/s" )
        
        render.setColor(Color(2,255,2, 192 - r_ping))
        render.drawCircle( x/2, y/2, r_ping )
        
    end)
 
end