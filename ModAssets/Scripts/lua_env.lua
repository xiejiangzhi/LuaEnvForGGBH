--[[
export functions
  ctypeof(obj)
  ctype(obj)
  log_print(ConsoleColor, string)
]]

print('[LuaEnv] Setup lua env...')

Inspect = require 'lib.inspect'
JSON = require 'lib.json'

require 'lua_env.import'
require 'lua_env.ext'
require 'lua_env.logger'

require 'lua_env.mod'

require 'lua_env.drama'

require 'lua_env_test.funcs_and_conds'

local DelayLoadLibs = { 'util', 'drama_helper' }
for i, v in ipairs(DelayLoadLibs) do DelayLoadLibs[k] = true end
LuaEnv = setmetatable({ }, {
  __index = function(t, k)
    if DelayLoadLibs[k] then
      local m = require('lua_env.'..k) or false
      rawset(t, k, m)
      return m
    end
  end
})
