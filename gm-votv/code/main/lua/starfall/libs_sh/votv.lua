local checkluatype = SF.CheckLuaType
local checkvalidnumber = SF.CheckValidNumber
local checkvector = SF.CheckVector

local ENT_META = FindMetaTable("Entity")
local PLY_META = FindMetaTable("Player")

local IsValid = FindMetaTable("Entity").IsValid

--- GM-VoTV Main Library
--@name votv
--@class library
--@libtbl votv_library
SF.RegisterLibrary("votv")

return function(instance)

    local ent_meta = instance.Types.Entity
    local player_methods, player_meta, wrap, unwrap = instance.Types.Player.Methods, instance.Types.Player, instance.Types.Player.Wrap, instance.Types.Player.Unwrap
    local owrap, ounwrap = instance.WrapObject, instance.UnwrapObject
    local ent_meta, ewrap, eunwrap = instance.Types.Entity, instance.Types.Entity.Wrap, instance.Types.Entity.Unwrap
    local vec_meta, vwrap, vunwrap = instance.Types.Vector, instance.Types.Vector.Wrap, instance.Types.Vector.Unwrap
    local ang_meta, awrap, aunwrap = instance.Types.Angle, instance.Types.Angle.Wrap, instance.Types.Angle.Unwrap
    local wep_meta, wwrap, wunwrap = instance.Types.Weapon, instance.Types.Weapon.Wrap, instance.Types.Weapon.Unwrap
    local veh_meta, vhwrap, vhunwrap = instance.Types.Vehicle, instance.Types.Vehicle.Wrap, instance.Types.Vehicle.Unwrap

    local Ply_Flashlight = PLY_META.Flashlight
    local Ply_FlashlightIsOn = PLY_META.FlashlightIsOn
    local Ply_AllowFlashlight = PLY_META.AllowFlashlight
    local Ply_CanUseFlashlight = PLY_META.CanUseFlashlight

    local votv_library = instance.Libraries.votv

    --- GM-VoTV Function. Toggles the flashlight for a player
    -- @server
    -- @param boolean isOn Whether the flashlight has to be turned on or not
    function player_methods:toggleFlashlight( isOn )

        local ply = unwrap(self)
        checkluatype( isOn, TYPE_BOOL )
        Ply_Flashlight( ply, isOn )

    end

    --- GM-VoTV Function. Sets if the player can toggle their flashlight. Function exists on both the server and client but has no effect when ran on the client.
    -- @param boolean canFlashlight True allows flashlight toggling
    function player_methods:allowFlashlight( canFlashlight )

        local ply = unwrap(self)
        checkluatype( canFlashlight, TYPE_BOOL )
        Ply_AllowFlashlight( ply, canFlashlight )

    end

    --- GM-VoTV Function. Returns true if the player's flashlight hasn't been disabled by Player:allowFlashlight.
    -- @return boolean Whether the player can use flashlight.
    function player_methods:CanUseFlashlight()

        return Ply_CanUseFlashlight(unwrap(self))

    end

end