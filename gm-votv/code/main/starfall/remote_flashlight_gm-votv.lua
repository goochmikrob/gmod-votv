--@name Remote Flashlight GM-VOTV
--@author Gooch
--@server

hook.add("Remote", "", function(sender, owner, payload) 
       
    if not istable( payload ) then return end
     
    if #payload >= 2 then
        
        local id = payload[1]
        local cmd = payload[2]
        
        if cmd == "flashlight " then
        
            concmd( tostring(cmd)..tostring(id).." 0")
            
        elseif cmd == "flashlight_enable " then
            
            local id = id.." "
            local allow = payload[3]
            concmd( tostring(cmd)..tostring(id)..tostring(allow) )
            
        end
        
    end
        
end)