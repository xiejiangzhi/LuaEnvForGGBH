local ModFuncs = {}
local ModConds = {}

local Util = LuaEnv.util

function AddFunc(name, fn, args_desc)
  name = tostring(name)
  if ModFuncs[name] then
    Log.warn('[LuaEnv] Replace script func '..name)
    Log.debug(debug.traceback())
  else
    Log.info("[LuaEnv] Add script func "..name)
  end

  -- Util.add_mod_func(name, args_desc)

  if args_desc then
    ModFuncs[name] = function(fn_name, df_or_dc, args)
      local parsed_args = args_desc and Util.parse_drama_args(df_or_dc, args, args_desc)
      fn(fn_name, df_or_dc, args, parsed_args)
    end
  else
    ModFuncs[name] = fn
  end
end

function AddCond(name, fn, args_desc)
  name = tostring(name)
  if ModConds[name] then
    Log.warn("[LuaEnv] Replace script cond "..name)
    Log.debug(debug.traceback())
  else
    Log.info("[LuaEnv] Add script cond "..name)
  end

  ModFuncs[name] = function(fn_name, dc, args)
    local parsed_args = args_desc and Util.parse_drama_args(dc, args, args_desc)
    fn(fn_name, dc, args, parsed_args)
  end
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