
Logger = {}

local function concat_objs(...)
  local r = {}
  for i = 1, select('#', ...) do
    local obj = select(i, ...)
    r[#r + 1] = tostring(obj)
  end
  return table.concat(r, '  ')
end

function Logger.debug(...)
  print_debug(concat_objs(...))
end

function Logger.info(...)
  print('[LuaEnv] '..concat_objs(...))
end

function Logger.warn(...)
  print_warn(concat_objs(...))
end

function Logger.error(...)
  print_error(concat_objs(...))
end
