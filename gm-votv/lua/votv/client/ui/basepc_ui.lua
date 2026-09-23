votv.base_pc = {}
votv.fprint("FILE INIT: basepc_ui.lua")

votv.base_pc.Panel = nil 

votv.gui.registerWindow("base_pc",{

    open = function(...)
        
        if votv.base_pc.Panel then return end 
        
        local pnl = vgui.Create("DFrame")
        votv.base_pc.Panel = pnl 

        pnl:SetSizable (false)
        pnl:MakePopup()
        pnl:SetSize(1024,768)
        pnl:Center()

    end,

    close = function(...)

        if votv.base_pc.Panel then
            
            local pnl = votv.base_pc.Panel
            pnl:Close()
            votv.base_pc.Panel = nil

        end

    end

})