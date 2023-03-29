local function xpcall_err_cb(msg)
  print('[Error]'..tostring(msg))
  print(debug.traceback())
end

function try_call(fn, ...)
  if not fn then return end
  return xpcall(fn, xpcall_err_cb, ...)
end



