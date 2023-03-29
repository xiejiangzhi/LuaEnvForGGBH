
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
  print('[Debug] '..concat_objs(...))
end

function Logger.info(...)
  print('[Info] '..concat_objs(...))
end

function Logger.warn(...)
  print('[Warn] '..concat_objs(...))
end

function Logger.error(...)
  print('[Error] '..concat_objs(...))
end
