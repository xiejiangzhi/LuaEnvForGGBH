Log = {}

local function concat_objs(...)
  local r = {}
  for i = 1, select('#', ...) do
    local obj = select(i, ...)
    r[#r + 1] = tostring(obj)
  end
  return table.concat(r, '  ')
end

local DebugColor = ConsoleColor.DarkGray
local WarnColor = ConsoleColor.Yellow
local ErrColor = ConsoleColor.Red
local InfoColor = ConsoleColor.Gray

function Log.debug(...)
  log_print(DebugColor, concat_objs(...))
end

function Log.info(...)
  log_print(InfoColor, concat_objs(...))
end

function Log.warn(...)
  log_print(WarnColor, concat_objs(...))
end

function Log.error(...)
  log_print(ErrColor, concat_objs(...))
end

Logger = Log
