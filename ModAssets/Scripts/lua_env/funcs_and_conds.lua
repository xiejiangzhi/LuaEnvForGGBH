
-- local DramaOptionFns = {}
-- --[[
--   code: return function(name, df, args) end
-- ]]
-- local function get_fn_by_drama_option_id(id)
--   local fn = DramaOptionFns[id]
--   if not fn then
--     local key = 'drama_option'..id
--     local ok, text = pcall(g.conf.LocalText.GetText, key)
--     if ok then
--       Logger.debug('load code from drama option: '..key)
--       fn = load(text, key)()
--       if type(fn) == 'function' then
--         DramaOptionFns[id] = fn
--       else
--         fn = nil
--         Logger.error("Code must return a function of "..key)
--       end
--     else
--       Logger.error("Failed to load code from "..key)
--     end
--   end
--   return fn
-- end

-- AddCond('codeFromOptId', function(name, dc, args)
--   local id = args.Length > 0 and args[0]
--   if not id then
--     Logger.error("Empty Id to call codeFromOptId")
--     return false
--   end

--   local fn = get_fn_by_drama_option_id(id)
--   if fn then
--     local r = xpcall(fn, xpcall_err_cb, name, dc, args)
--     return r and true or false
--   else
--     return false
--   end
-- end)

-- AddFunc('codeFromOptId', function(name, dc, args)
--   local id = args.Length > 0 and args[0]
--   if not id then
--     Logger.error("Empty Id to call codeFromOptId")
--     return false
--   end

--   local fn = get_fn_by_drama_option_id(id)
--   if fn then
--     local r = xpcall(fn, xpcall_err_cb, name, dc, args)
--     return r and true or false
--   else
--     return false
--   end
-- end)

-- df: DramaFunction
AddFunc('test-func', function(name, df, args)
  Logger.info('Inside lua test func', name, df, args)
  Logger.info('left', df.data.unitLeft)
  Logger.info('right', df.data.unitRight)
  Logger.info('UnitA', df.data.unitA)
  Logger.info('g', g, g.world.playerUnit)
  for i = 0, args.Length - 1 do
    Logger.log(i, args[i])
  end
end)

-- cond DramaCondition
AddCond('test-cond', function(name, dc, args)
  Logger.info('Inside lua test cond', name, dc, args)
  Logger.info('unitA', dc.data.unitA)
  Logger.info('unitB', dc.data.unitB)
  Logger.info('unitC', dc.data.unitC)
  Logger.info('args len', args.Length)
  for i = 0, args.Length - 1 do
    Logger.info(i, args[i])
  end
  -- must return a bool value for condition
  return true
end)

