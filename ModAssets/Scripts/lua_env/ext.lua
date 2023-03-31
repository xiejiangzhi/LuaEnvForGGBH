local PrintColor = ConsoleColor.Gray
print = function(...)
  local str = {}
  for i = 1, select('#', ...) do
    str[#str + 1] = tostring(select(i, ...))
  end
  log_print(PrintColor, table.concat(str, '\t'))
end

local function xpcall_err_cb(msg)
  Log.error('[Error] '..tostring(msg))
  Log.error(debug.traceback())
end

function try_call(fn, ...)
  if not fn then return end
  return xpcall(fn, xpcall_err_cb, ...)
end
