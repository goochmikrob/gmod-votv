AddCSLuaFile()

votv = votv or {}

local dgetmeta = debug.getmetatable

function votv.throwError(msg,lvl)

    if msg then
        if SERVER then 
            error(msg,lvl)
        end
        if CLIENT then
            notification.AddLegacy( msg, NOTIFY_ERROR, 9 )
            surface.PlaySound("buttons/button10.wav")
            error(msg,lvl)
        end
    end 

end

function votv.throwTypeError(expected,got,lvl)

    local level = 1 + (level or 1)
    local funcname = debug.getinfo(level+1,"n").name or "<unnamed?>"

    votv.throwError("Type mismatch (Expected " .. expected .. ", got " .. got .. ") in function " .. funcname, lvl)

end 

votv.TypeNames = {
	[TYPE_NONE]             = "Invalid type",
	[TYPE_NIL]              = "nil",
	[TYPE_BOOL]             = "boolean",
	[TYPE_LIGHTUSERDATA]    = "light userdata",
	[TYPE_NUMBER]           = "number",
	[TYPE_STRING]           = "string",
	[TYPE_TABLE]            = "table",
	[TYPE_FUNCTION]         = "function",
	[TYPE_USERDATA]         = "userdata",
	[TYPE_THREAD]           = "thread",
	[TYPE_ENTITY]           = "Entity",
	[TYPE_VECTOR]           = "Vector",
	[TYPE_ANGLE]            = "Angle",
	[TYPE_PHYSOBJ]          = "PhysObj",
	[TYPE_SAVE]             = "ISave",
	[TYPE_RESTORE]          = "IRestore",
	[TYPE_DAMAGEINFO]       = "CTakeDamageInfo",
	[TYPE_EFFECTDATA]       = "CEffectData",
	[TYPE_MOVEDATA]         = "CMoveData",
	[TYPE_RECIPIENTFILTER]  = "CRecipientFilter",
	[TYPE_USERCMD]          = "CUserCmd",
	[TYPE_SCRIPTEDVEHICLE]  = "ScriptedVehicle", -- Deprecated, also TYPE Enum doesn't specify the name so this it is
	[TYPE_MATERIAL]         = "IMaterial",
	[TYPE_PANEL]            = "Panel",
	[TYPE_PARTICLE]         = "CLuaParticle",
	[TYPE_PARTICLEEMITTER]  = "CLuaEmitter",
	[TYPE_TEXTURE]          = "ITexture",
	[TYPE_USERMSG]          = "bf_read",
	[TYPE_CONVAR]           = "ConVar",
	[TYPE_IMESH]            = "IMesh",
	[TYPE_MATRIX]           = "VMatrix",
	[TYPE_SOUND]            = "CSoundPatch",
	[TYPE_PIXELVISHANDLE]   = "pixelvis_handle_t",
	[TYPE_DLIGHT]           = "dlight_t",
	[TYPE_VIDEO]            = "IVideoWriter",
	[TYPE_FILE]             = "File",
	[TYPE_LOCOMOTION]       = "CLuaLocomotion",
	[TYPE_PATH]             = "PathFollower",
	[TYPE_NAVAREA]          = "CNavArea",
	[TYPE_SOUNDHANDLE]      = "IGModAudioChannel",
	[TYPE_NAVLADDER]        = "CNavLadder",
	[TYPE_PARTICLESYSTEM]   = "CNewParticleEffect",
	[TYPE_PROJECTEDTEXTURE] = "ProjectedTexture",
	[TYPE_PHYSCOLLIDE]      = "PhysCollide",
	[TYPE_SURFACEINFO]      = "SurfaceInfo",
	[TYPE_COLOR]            = "Color" -- TypeID doesn't return this but lets still add it
}

function votv.getType(val)
    local meta = dgetmeta(val)
	return meta and isstring(meta.__metatable) and meta.__metatable or type(val)
end

function votv.typeName( typeid )
    return assert(votv.TypeNames[typeid],"Type not defined!")
end 

function votv.checkLuaType(val, typ, argname)

    if TypeID(val) ~= typ then

        local info = debug.getinfo(2, "nSl")
        local funcname = info.name or "<unnamed?>"
        local src = info.short_src or "<unknown>"
        local line = info.currentline or 0
        local name = argname and ("'" .. argname .. "'") or "argument"
        
        votv.throwError(
            "Type mismatch (" .. name .. ": expected " .. votv.typeName(typ) ..
            ", got " .. votv.getType(val) .. ") in function " .. funcname ..
            " at " .. src .. ":" .. line, 2
        )

    end

end

function votv.zerowait( fn )

    -- A bit filthy method, but actually working

    timer.Simple( 0, function()

        local ok, err = pcall(fn)
        if not ok then votv.throwError(err) end

    end)

end

function votv.fprint(...)

    if SERVER then
    
        MsgC(Color(85,120,255),"[GM-VoTV] [Serverside] ",color_white,... .. "\n")
    
    end

    if CLIENT then
    
        MsgC(Color(85,125,255),"[GM-VoTV] [Clientside] ",color_white,... .. "\n")

    end   
end 

votv.fprint("FILE INIT: votvlib.lua")

if SERVER then
    
end

if CLIENT then
    
end