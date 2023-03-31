--[[
export functions
  typeof(obj)
  ctype(obj)
  log_print(ConsoleColor, string)
  call_obj_method
]]

print('[LuaEnv] Setup lua env...')

Inspect = require 'lua_env.inspect'

require 'lua_env.import'
require 'lua_env.ext'
require 'lua_env.logger'

require 'lua_env.mod'

require 'lua_env.drama'

require 'lua_env_test.funcs_and_conds'
