local M = {}

local DramaHelper = require 'lua_env.drama_helper'

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
    -- local params = m:GetParameters()
    if m.Name == method_name and (not filter or filter(m)) then
      return function(...)
        return M.invoke_method(m, ...)
      end, m
    end
  end
end

function M.invoke_method(method, obj, ...)
  local obj_type = luanet.import_type('System.Object')
  local margs = luanet.make_array(obj_type, { ... })
  return method:Invoke(obj, margs)
end

--[[
args_desc: {
  'name', -- don't convert type, use defautl string type
  { 'name', 'type', 'fn_type' }, -- convert to the type. valid type: number, unit, int
  ...
}
]]
function M.parse_drama_args(df_or_dc, args, args_desc)
  local r = {}
  local is_df = ctype(df_or_dc) == "DramaFunction"
  local len = args.Length

  r.raw_args = {}
  r.n = math.min(len, #args_desc)
  for i, arg_desc in ipairs(args_desc) do
    if i > len then break end
    local v = args[i - 1]

    local arg_name, arg_type
    if type(arg_desc) == 'table' then
      arg_name, arg_type = arg_desc[1], arg_desc[2]
      r.raw_args[arg_name] = v
      if arg_type == 'number' then
        v = tonumber(v)
      elseif arg_type == 'unit' then
        if is_df then
          v = DramaHelper.get_df_unit(df_or_dc, v)
        else
          v = DramaHelper.get_dc_unit(df_or_dc, v)
        end
      elseif arg_type == 'int' then
        v = math.floor(tonumber(v))
      elseif arg_type == 'mapping' then
        v = arg_desc[3][v]
      else
        Log.error("Invalid arg type "..tostring(arg_type).. ' of '..tostring(arg_name))
      end
    else
      arg_name = arg_desc
      r.raw_args[arg_name] = v
    end
    r[arg_name] = v
  end
  return r
end

function M.add_mod_func(name, args_desc)
  local conf_mf = g.conf.modFunction
  local call_id = "addFeature_lua_"..name
  local title = "addFeature_lua_"..name
  local id = conf_mf.items.Count
  local req_npc = Il2CppStringArray(luanet.make_array(String, { }))
  local fn_item = ConfModFunctionItem()
  fn_item.id = id
  fn_item.title = title
  fn_item.key = call_id
  fn_item.isShow = 1
  fn_item.requireNPC = req_npc

  for idx = 1, 8 do
    local vtype
    if args_desc then
      if args_desc[idx] then
        fn_item['value'..idx] = args_desc[idx][3] or 'String'
      else
        vtype = '0'
      end
    end

    fn_item['value'..idx] = vtype or '0'
    fn_item['value'..idx..'Name'] = '0'
    fn_item['value'..idx..'Desc'] = '0'
  end

  conf_mf:AddItem(fn_item)
  conf_mf.items:Add(call_id, fn_item)
end

return M
