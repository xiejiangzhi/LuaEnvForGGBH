
local FnsMap = {}
local NextFnId = 1

function _GlobalEventActionCallback(id, ...)
  local fn = FnsMap[id]
  print('event cb', id, fn, ...)
  if fn then
    try_call(fn, ...)
  end
end

function NewDelegate(fn)
  local id = tostring(NextFnId)
  NextFnId = NextFnId + 1
  local dg = NewLuaFnDelegate0('_GlobalEventActionCallback', id)
  print(dg)
  FnsMap[id] = fn
  return dg, id
end

function NewDelegate1(param_type, fn)
  local id = tostring(NextFnId)
  NextFnId = NextFnId + 1
  local dg = NewLuaFnDelegate1('_GlobalEventActionCallback', id, luanet.ctype(param_type))
  print(dg)
  FnsMap[id] = fn
  return dg, id
end

function ClearActionData(id)
  FnsMap[id] = nil
end

