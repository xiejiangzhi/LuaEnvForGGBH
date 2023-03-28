local M = {}

local ModFuncs = {}
local ModConds = {}


function AddFunc(name, fn)
  name = tostring(name)
  if ModFuncs[name] then
    print_warn("Replace script func "..name)
    print(debug.traceback())
  else
    print("[LuaEnv] Add script func "..name)
  end
  ModFuncs[name] = fn
end

function AddCond(name, fn)
  name = tostring(name)
  if ModConds[name] then
    print_warn("Replace script cond "..name)
    print(debug.traceback())
  else
    print("[LuaEnv] Add script cond "..name)
  end
  ModConds[name] = fn
end

function ExecFunc(name, ...)
  print_debug('exec lua func '..tostring(name))
  local fn = ModFuncs[name]
  if fn then
    try_call(fn, name, ...)
  else
    print_error("Not found script func "..tostring(name))
  end
end

function ExecCond(name, ...)
  print_debug('exec lua cond '..tostring(name))
  local fn = ModConds[name]
  if fn then
    local ok, r = try_call(fn, name, ...)
    if ok then
      return r and true or false
    else
      return false
    end
  else
    print_error("Not found script func "..tostring(name))
  end
end