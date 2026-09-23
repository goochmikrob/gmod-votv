votv = votv or {}
votv.fprint("FILE INIT: gui_manager.lua")

votv.gui = {}

votv.gui.windows = {}
votv.gui.actions = {}

local checkluatype = votv.checkLuaType

function votv.gui.registerWindow( name, handlers )
    
    checkluatype(name,TYPE_STRING)
    checkluatype(handlers,TYPE_TABLE)
    votv.gui.windows[name] = handlers

end

function votv.gui.registerAction( name, fn )

    checkluatype(name,TYPE_STRING)
    checkluatype(fn,TYPE_FUNCTION)
    votv.gui.actions[name] = fn

end

function votv.gui.open( name, ... )

    checkluatype(name,TYPE_STRING)
    local fn = votv.gui.windows[name]
    if fn and fn.open then fn.open(...) end

end

function votv.gui.close( name, ... )

    checkluatype(name,TYPE_STRING)
    local fn = votv.gui.windows[name]
    if fn and fn.close then fn.close(...) end

end 

function votv.gui.perform(payload)
    
    checkluatype(payload,TYPE_TABLE)
    
    if not votv.gui.actions[payload.action] then
        votv.throwError("votv.gui.perform: attempt to call a nil value (No such action!)")
    end

    local fn = votv.gui.actions[payload.action]
    if fn then fn(payload) end

end 