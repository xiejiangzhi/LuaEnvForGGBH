
local reloader = require('lua_env.auto_reloader').new(LuaEnvModDir, _ENV)
-- default is enable
-- reloader:enable()
-- reloader:disable()

-- df: DramaFunction
AddFunc('test-func', function(name, df, args)
  return reloader:load('lua_env_test.impl').test_func(name, df, args)
end)

-- cond DramaCondition
AddCond('test-cond', function(name, dc, args)
  return reloader:load('lua_env_test.impl').test_cond(name, dc, args)
end)

