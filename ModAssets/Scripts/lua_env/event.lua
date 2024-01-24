local EventCbs = {}

-- EBattleType
-- EGameType
-- EMapType
function BindEvent(name, fn, count)
  local action, id = NewDelegate1(ETypeData, fn)
  print(action)
  local cbs = EventCbs[name]
  if not cbs then
    cbs = {}
    EventCbs[name] = cbs
  end
  if cbs[fn] then
    return
  end
  cbs[fn] = { name = name, id = id, action = action }
  Log.debug("Bind event "..tostring(name))
  -- todo get method
  local on_fn = LuaEnv.util.get_method(g.events:GetType(), 'On', function(m)
    local ps = m:GetParameters()
    return ps.Length == 4 and ps[1].ParameterType.Name == 'Action`1'
  end)
  on_fn(g.events, name, action, count or -1, true)
end

function UnbindEvent(name, fn)
  local cbs = EventCbs[name]
  if not cbs then return end
  local einfo = cbs[fn]
  if not einfo then return end
  Log.debug("Unbind event "..tostring(name))
  cbs[fn] = nil
  ClearActionData(einfo.id)
  g.events:Off(name, einfo.action)
end

