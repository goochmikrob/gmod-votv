if SERVER then

    AddCSLuaFile()

    concommand.Add("flashlight", function(ply, cmd, args)

        if not ply:IsSuperAdmin() then return end
        
        if #args < 2 then
            ply:ChatPrint("Использование: flashlight <id игрока> <1|0>")
            ply:ChatPrint("Пример: flashlight 1 0 - выключить фонарик у игрока с ID=1")
            return
        end
        
        local id = tonumber(args[1])
        if not id then
            ply:ChatPrint("ID должен быть числом!")
            return
        end
        
        local on = args[2] == "1" or args[2] == "true" or args[2] == "on"
        
        local target = Entity(id)
        
        if not IsValid(target) then
            ply:ChatPrint("Игрок с ID " .. id .. " не найден")
            return
        end
        
        if not target:IsPlayer() then
            ply:ChatPrint("Entity с ID " .. id .. " не является игроком")
            return
        end
        
        target:Flashlight(on)

    end)

    concommand.Add("flashlight_enable", function(ply, cmd, args)

        if not ply:IsSuperAdmin() then return end
        
        if #args < 1 then
            ply:ChatPrint(table.concat(args, ", "))
            ply:ChatPrint("Использование: flashlight_enable <id игрока> <1|0>")
            ply:ChatPrint("Пример: flashlight_enable 1 0 - запретить фонарик у игрока с ID=1")
            return
        end
        
        local id = tonumber(args[1])
        if not id then
            ply:ChatPrint("ID должен быть числом!")
            return
        end
        
        local on = args[2] == "1" or args[2] == "true" or args[2] == "on"
        
        local target = Entity(id)
        
        if not IsValid(target) then
            ply:ChatPrint("Игрок с ID " .. id .. " не найден")
            return
        end
        
        if not target:IsPlayer() then
            ply:ChatPrint("Entity с ID " .. id .. " не является игроком")
            return
        end
        
        target:AllowFlashlight(on)

    end)

end