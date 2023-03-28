--[[
export functions
  cprint(a, b, c, ...) like print
  print_debug(string)
  print_warn(string)
  print_error(string)

  typeof(obj)
  ctype(obj)
]]

function print(...)
  _G.cprint(...)
end
_G.set_enable_debug_log(false)

print('Setup lua env.')

require 'lua_env.logger'

require 'lua_env.import'
require 'lua_env.CLRPackage'
require 'lua_env.ext'

require 'lua_env.drama'
require 'lua_env.funcs_and_conds'

