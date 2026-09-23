votv = {}

if SERVER then 
		
	AddCSLuaFile("votv/votvlib.lua")
	AddCSLuaFile("votv/client/ui/gui_manager.lua")

	AddCSLuaFile("votv/client/ui/basepc_ui.lua")
	AddCSLuaFile("votv/client/ui/transformer_ui.lua")

	include("votv/votvlib.lua")
	include("votv/server/player_manager.lua")

end

if CLIENT then

	include("votv/votvlib.lua")
	include("votv/client/ui/gui_manager.lua")
	
	include("votv/client/ui/basepc_ui.lua")
	include("votv/client/ui/transformer_ui.lua")

end 