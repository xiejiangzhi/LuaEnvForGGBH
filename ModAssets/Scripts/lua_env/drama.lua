local M = {}

local ModFuncs = {}
local ModConds = {}


function AddFunc(name, fn)
  name = tostring(name)
  if ModFuncs[name] then
    Log.warn('[LuaEnv] Replace script func '..name)
    Log.debug(debug.traceback())
  else
    Log.info("[LuaEnv] Add script func "..name)
  end
  ModFuncs[name] = fn
end

function AddCond(name, fn)
  name = tostring(name)
  if ModConds[name] then
    Log.warn("[LuaEnv] Replace script cond "..name)
    Log.debug(debug.traceback())
  else
    Log.info("[LuaEnv] Add script cond "..name)
  end
  ModConds[name] = fn
end

function ExecFunc(name, ...)
  Log.debug('[LuaEnv] exec lua func '..tostring(name))
  local fn = ModFuncs[name]
  if fn then
    try_call(fn, name, ...)
  else
    Log.error("[LuaEnv] Not found script func "..tostring(name))
  end
end

function ExecCond(name, ...)
  Log.debug('[LuaEnv] exec lua cond '..tostring(name))
  local fn = ModConds[name]
  if fn then
    local ok, r = try_call(fn, name, ...)
    if ok then
      return r and true or false
    else
      return false
    end
  else
    Log.error("[LuaEnv] Not found script func "..tostring(name))
  end
end