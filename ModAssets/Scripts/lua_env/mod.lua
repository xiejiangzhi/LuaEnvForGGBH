local Util = require 'lua_env.util'
local AutoReloader = require 'lua_env.auto_reloader'

--[[
隔离不同 mod 的环境，并将 require 定位到自己的 mod Scripts 目录
mod 的 main.lua 中可以从全局变量取到自己的 ModId 与 ModDir
框架本身不提供 hotreload，可以自己在脚本中每次都执行 loadfile 来加载最新的脚本
]]
function LoadMod(id, dir, main_path)
  print('[LuaEnv] Start load mod ', id)

  local raw_require = require
  local env = setmetatable({ ModId = id, ModDir = dir }, { __index = _ENV or _G })
  env._G = env
  env.reloader = AutoReloader.new(dir, env)

  env.require = function(module_name)
    local old_path = package.path
    package.path = dir..'/?.lua;'..dir..'/?/init.lua;'..package.path
    local m
    for i, searcher in ipairs(package.searchers) do
      local loader, path = searcher(module_name)
      if loader and path then
        Util.setfenv(loader, env)
        m = loader(path)
        break
      end
    end
    package.path = old_path
    return m
  end

  env.auto_load = function(module)
    return env.reloader:load(module)
  end

  try_call(function()
    -- 两种模式，支持编译好的二进制 lua 文件
    local fn = loadfile(main_path, 'bt', env)
    if fn then
      fn()
    end
  end)
end


