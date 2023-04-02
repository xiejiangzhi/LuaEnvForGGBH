local M = {}

M.setfenv = setfenv or function(f, t)
  f = (type(f) == 'function' and f or debug.getinfo(f + 1, 'f').func)
  local name
  local up = 0
  repeat
    up = up + 1
    name = debug.getupvalue(f, up)
  until name == '_ENV' or name == nil
  if name then
    debug.upvaluejoin(f, up, function() return name end, 1) -- use unique upvalue
    debug.setupvalue(f, up, t)
  end
end

-- slow, call once and save return to use
function M.get_generic_method(c_type, method_name, generic_type, filter)
  local methods = c_type:GetMethods()
  for i = 0, methods.Length - 1 do
    local m = methods[i]
    if m.Name == method_name and m.IsGenericMethod and (not filter or filter(m)) then
      local gm = m:MakeGenericMethod(generic_type)
      return function(...)
        return M.invoke_method(gm, ...)
      end
    end
  end
end

-- slow, call once and save return to use
function M.get_method(c_type, method_name, filter)
  local methods = c_type:GetMethods()
  for i = 0, methods.Length - 1 do
    local m = methods[i]
    if m.Name == method_name and (not filter or filter(m)) then
      return function(...)
        return M.invoke_method(m, ...)
      end
    end
  end
end

function M.invoke_method(method, obj, ...)
  local obj_type = luanet.import_type('System.Object')
  local margs = luanet.make_array(obj_type, { ... })
  return method:Invoke(obj, margs)
end

return M
