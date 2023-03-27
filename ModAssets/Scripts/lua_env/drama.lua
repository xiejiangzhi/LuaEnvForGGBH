local M = {}

local ModFuncs = {}
local ModConds = {}

function LoadMod(id, dir, main_path)
  print('[LuaEnv] Start load mod ', id, dir, main_path)

  local env = setmetatable({}, { __index = _ENV })
  env.require = function(path)
    local old_path = package.path
    package.path = dir..'/?.lua;'..dir..'/?/init.lua;'..package.path
    local r = _ENV.require(path)
    package.path = old_path
    return r
  end
  local ok, fn = xpcall(loadfile, xpcall_err_cb, main_path, 'bt', env)
  if ok then
    xpcall(fn, xpcall_err_cb, id, dir)
  end
end

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
    fn(name, ...)
  else
    print_error("Not found script func "..tostring(name))
  end
end

function ExecCond(name, ...)
  print_debug('exec lua cond '..tostring(name))
  local fn = ModConds[name]
  if fn then
    local r = fn(name, ...)
    return r and true or false
  else
    print_error("Not found script func "..tostring(name))
  end
end