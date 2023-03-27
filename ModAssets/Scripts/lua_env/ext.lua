function cpairs(obj)
  local can_pair = type(obj) == 'userdata' and obj.GetEnumerator ~= nil

  if not can_pair then
    error("Cannot exec 'cpairs' for obj "..type(obj))
  end

  local i = 0
  local e = obj:GetEnumerator()

  return function()
    if e:MoveNext() then
      local k = i
      local v = e.Current
      i = i + 1
      return k, v
    end
  end, obj
end

function xpcall_err_cb(msg)
  print_error('[Error]'..msg)
  print_error(debug.traceback())
end